require 'date'
class Api::TimelogController < ApplicationController
    def all
        permitted = params.permit(:project_id)
        project = Project.find_by(id: permitted[:project_id].to_i)
        if project.nil?
            raise '你沒有任何專案'
        end
        timelogs = project.timelogs.order(:id)
        loc = {}
        timelogs.each do |timelog|
            loc[timelog.id] = get_loc_between_week(timelog)
        end
        timelogs_json = timelogs.as_json(
            include: {
                time_costs: {
                    include: {
                        student: {
                            only: [:name, :id]
                        }
                    },
                    only: [:id, :cost]
                }
            }, only: [:id, :week_no, :date, :todo]
        )
        timelogs_json.each do |timelog|
            timelog['loc'] = loc[timelog['id']]
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
        permitted = params.permit(:timelog_id, :cost, :todo)
        verify_student_timelog_owner!(permitted[:timelog_id].to_i)
        timelog = Timelog.find_by(id: permitted[:timelog_id].to_i)
        if timelog.nil?
            raise '沒有這個Timelog'
        end
        time_cost = TimeCost.find_by(student_id: @student.id, timelog_id: timelog.id)
        ActiveRecord::Base.transaction do
            timelog.update_attributes!(todo: permitted[:todo])
            if time_cost.nil?
                TimeCost.create!(student_id: @student.id,
                                 timelog_id: timelog.id,
                                 cost: permitted[:cost].to_i)
            else
                time_cost.update_attributes!(cost: permitted[:cost].to_i)
            end
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

    def create
        retrieve_admin
        permitted = params.permit(:date)
        date = DateTime.rfc2822(permitted[:date])
        timelogs = Timelog.where(date: (date - 7)..date)
        if timelogs.count != 0
            return render HttpStatusCode.forbidden(
                {
                    errorMsg: '每一周只能一次有一個Timelog'
                }
            )
        end
        Timelog.transaction do
            timelog = Timelog.order(:week_no).last
            week_no = 0
            unless timelog.nil?
                week_no = timelog.week_no + 1
            end
            projects = Project.all
            projects.each do |project|
                Timelog.create!(week_no: week_no, date: date, project_id: project.id)
            end
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

    def get_loc_between_week(timelog)
        git = Git.bare("#{APP_CONFIG['git_project_root']}oopcourse#{timelog.project.id}.git")
        current_date = timelog.date
        before_date = timelog.date - 1.week
        first_commit = nil
        last_commit = nil
        commits = []
        begin
            commits = git.log(9999999)
        rescue
            nil
        end
        commits.each do |commit|
            if commit.date.to_date < before_date
                break
            end
            if commit.date.to_date >= before_date and commit.date.to_date <= current_date and last_commit.nil?
                last_commit = commit
            end
            if commit.date.to_date >= before_date  and commit.date.to_date <= current_date
                first_commit = commit
            end
        end
        if last_commit.nil? and first_commit.nil?
            return 0
        end
        # Log.info("Last commit is #{last_commit.message} and First commit is #{first_commit.message}")
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
        if @teaching_assistant.nil? and @admin.nil?
            raise '憑證失效'
        end
    end

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end
end
