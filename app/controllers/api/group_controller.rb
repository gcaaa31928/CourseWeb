class Api::GroupController < ApplicationController

    def create
        retrieve_student
        permitted = params.permit(:student_id)
        group = Group.create
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
            member.update_attributes(group_id: group.id)
            @student.update_attributes(group_id: group.id)
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
        retrieve_student
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
        retrieve_student
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

    def retrieve_student
        require_headers
        @student = Student.find_by(access_token: @access_token)
        if @student.nil?
            raise '憑證失效'
        end
    end

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end
end
