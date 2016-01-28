class Api::TimelogController < ApplicationController
    def all
        permitted = params.permit(:project_id)
        project = Project.find_by(id: permitted[:project_id].to_i)
        if project.nil?
            raise '你沒有任何專案'
        end
        timelogs = project.timelogs
        render HttpStatusCode.ok(timelogs.as_json(
            include: {
                time_costs: {
                    include: {
                        student: {
                            only: :name
                        }
                    },
                    only: [:id, :cost]
                }
            }, only: [:id, :week_no, :date, :todo]
        ))
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def edit
        retrieve_student!
        permitted = params.permit(:timelog_id, :cost, :todo)
        verify_student_timelog_owner!(permitted[:timelog_id].to_i)
        timelog = Timelog.find_by(id: permitted[:timelog_id].to_i)
        if timelog.nil?
            raise '沒有這個Timelog'
        end
        time_cost = TimeCost.find_by(student_id: @student.id, timelog_id: timelog.id)
        Log.info(time_cost.to_json)
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


    private

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

    def retrieve_student!
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
