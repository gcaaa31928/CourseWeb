require 'http_status_code'
class Api::TimeCostController < ApplicationController

    def add
        retrieve_student
        permitted = params.permit(:timelog_id, :cost, :category)
        verify_student_timelog_owner!(permitted[:timelog_id].to_i)
        TimeCost.create(timelog_id: permitted[:timelog_id].to_i,
                        cost: permitted[:cost].to_i,
                        category: permitted[:category].to_i,
                        student_id: @student.id)
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def destroy
        retrieve_student
        permitted = params.permit(:time_cost_id)
        time_cost = TimeCost.find_by(id: permitted[:time_cost_id])
        unless time_cost.can_destroy?(@student)
            raise '你沒有權限可以刪除這個time cost'
        end
        time_cost.destroy!
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end


    def all
        retrieve_student
        permitted = params.permit(:timelog_id)
        verify_student_timelog_owner!(permitted[:timelog_id].to_i)
        time_costs = TimeCost.where(timelog_id: permitted[:timelog_id], student_id: @student.id)
        render HttpStatusCode.ok(time_costs.as_json(
            include: {
                student: {
                    only: [:name, :id]
                }
            },
            only: [:id, :cost, :category]
        ))
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
