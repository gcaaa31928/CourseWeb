class Api::GroupController < ApplicationController

    def all
        retrieve
        permitted = params.permit(:course_id)
        if @student
            unless same_course?(permitted[:course_id].to_i)
                raise '你沒有權限執行這個操作'
            end
        end
        groups = Group.includes(:students, :project).where(course_id: permitted[:course_id].to_i).uniq
        groups.order!(:id)
        average_data = {}
        groups.each do |group|
            if group.project
                average_score = group.project.scores.group(:no).average(:point)
                average_score.each do |key, score|
                    average_score[key] = score.to_i
                end
                average_data[group.project.id] = average_score
            end
        end
        groups_json = groups.as_json(
            include: {
                students: {
                    only: [:id, :name]
                },
                project: {
                    include: {
                        scores: {
                            only: [:no, :point]
                        }
                    },
                    only: [:name, :id]
                }
            }, only: [:id]
        )
        groups_json.each do |group|
            if group['project']
                group['project']['average_point'] = average_data[group['project']['id']]
            end
        end
        render HttpStatusCode.ok(groups_json)

    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def create
        retrieve
        permitted = params.permit(:student_id)
        group = Group.create(course_id: @student.course.id)
        if permitted[:student_id].nil? or permitted[:student_id] == ''
            @student.update_attributes(group_id: group.id)
            render HttpStatusCode.ok
        else
            # have group member
            member = Student.find_by(id: permitted[:student_id].to_i)
            if member.nil?
                raise '找不到對方組員'
            end
            unless member.group.nil?
                raise '對方組員已經加入團隊'
            end
            Student.transaction do
                member.update_attributes(group_id: group.id)
                @student.update_attributes(group_id: group.id)
            end
            render HttpStatusCode.ok
        end
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def destroy
        retrieve
        group = @student.group
        if group.nil?
            raise '目前沒有團隊'
        end
        students = Student.where(group_id: group.id)
        Student.transaction do
            students.each do |student|
                student.update_attributes!(group_id: nil)
            end
        end
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def show
        retrieve
        group = @student.group
        if group.nil?
            return render HttpStatusCode.ok([])
        end
        students = Student.where(group_id: group.id)
        render HttpStatusCode.ok(students.as_json(only: [:id, :name]))
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    private

    def same_course?(course_id)
        @student.course_id == course_id
    end

    def retrieve
        require_headers
        retrieve_student
        retrieve_admin
        if @student.nil? and @teaching_assistant.nil? and @admin.nil?
            raise '憑證失效'
        end
    end

    def retrieve_student
        if @access_token.present?
            @student = Student.find_by(access_token: @access_token)
        end
    end

    def retrieve_admin
        if @access_token.present?
            @teaching_assistant = TeachingAssistant.find_by(access_token: @access_token)
            @admin = Admin.find_by(access_token: @access_token)
        end
    end

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end
end
