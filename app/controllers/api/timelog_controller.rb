require 'date'
class Api::TimelogController < ApplicationController
    def all
        permitted = params.permit(:project_id)
        project = Project.find_by(id: permitted[:project_id].to_i)
        if project.nil?
            raise '你沒有任何專案'
        end
        timelogs = project.timelogs.order(:week_no)
        loc = {}
        timelogs.each do |timelog|
            loc[timelog.id] = get_loc(timelog)
        end
        timelogs_json = timelogs.as_json(
            include: {
                time_costs: {
                    include: {
                        student: {
                            only: [:name, :id]
                        }
                    },
                    only: [:id, :cost, :category]
                },
            },
            methods: [:image_url],
            only: [:id, :week_no, :date, :todo, :acceptance]
        )
        timelogs_json.each do |timelog|
            timelog['loc'] = loc[timelog['id']]
            timelog['sum_cost'] = {}
            timelog['time_costs'].each do |time_cost|
                timelog['sum_cost'][time_cost['student']['id']] ||= 0
                timelog['sum_cost'][time_cost['student']['id']] += time_cost['cost']
            end
        end
        render HttpStatusCode.ok(timelogs_json)
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def edit
        retrieve_student
        permitted = params.permit(:timelog_id, :todo, :image)
        verify_student_timelog_owner!(permitted[:timelog_id].to_i)
        timelog = Timelog.find_by(id: permitted[:timelog_id].to_i)
        if timelog.nil?
            raise '沒有這個Timelog'
        end
        timelog.todo = permitted[:todo]
        timelog.save!
        render HttpStatusCode.ok
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def upload_image
        retrieve_admin
        if @admin.nil? and @teaching_assistant.nil?
            retrieve_student
        end
        timelog = Timelog.find_by(id: params[:timelog_id].to_i)
        if @student
            verify_student_timelog_owner!(params[:timelog_id].to_i)
        end

        if timelog.nil?
            raise '沒有這個Timelog'
        end
        timelog.image = params[:file]
        timelog.save!
        render HttpStatusCode.ok
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def edit_acceptance
        retrieve_admin
        verify_admin_present?
        permitted = params.permit(:timelog_id, :acceptance)
        timelog = Timelog.find_by(id: permitted[:timelog_id].to_i)
        if timelog.nil?
            raise '沒有這個Timelog'
        end
        timelog.update_attributes!(acceptance: permitted[:acceptance])
        render HttpStatusCode.ok
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def create
        retrieve_admin
        verify_admin_present?
        permitted = params.permit(:date, :course_id)
        date = Time.at(permitted[:date].to_i / 1000).to_date
        projects = Project.joins(:group).where(groups: {course_id: permitted[:course_id]})
        projects.each do |project|
            timelogs = project.timelogs.where(date: date)
            if timelogs.count != 0
                next
            end
            timelog = project.timelogs.order(:week_no).last
            week_no = 0
            if timelog
                week_no = timelog.week_no + 1
            end
            Timelog.create!(week_no: week_no, date: date, project_id: project.id)
        end
        render HttpStatusCode.ok
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    private

    def get_loc(timelog)
        git = Git.bare("#{APP_CONFIG['git_project_root']}oopcourse#{timelog.project.id}.git")
        current_date = timelog.date
        commits = []
        begin
            commits = git.log(9999999)
            last_commit = commits[-1]
            first_commit = commits[-1]
            commits.each do |commit|
                if commit.date.to_date <= current_date
                    last_commit = commit
                    break
                end
            end
        rescue
            nil
        end
        if last_commit.nil? and first_commit.nil?
            return 0
        end
        git.diff(first_commit, last_commit).insertions.to_i
    end


    def verify_student_timelog_owner!(timelog_id)
        timelog = Timelog.find_by(id: timelog_id)
        students = timelog.project.group.students
        students.each do |student|
            if student.id == @student.id
                return true
            end
        end
        raise '你沒有權限操作這個Timelog'
    end

    def retrieve_student
        require_headers
        @student = Student.find_by(access_token: @access_token)
        if @student.nil?
            raise '憑證失效'
        end
    end

    def retrieve_admin
        require_headers
        if @access_token.present?
            @teaching_assistant = TeachingAssistant.find_by(access_token: @access_token)
            @admin = Admin.find_by(access_token: @access_token)
        end

    end

    def verify_admin_present?
        if @teaching_assistant.nil? and @admin.nil?
            raise '憑證失效'
        end
    end

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end
end
