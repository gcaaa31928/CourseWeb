class TimeCostController < ApplicationController

    def add
        retrieve_student
        permitted = params.permit(:timelog_id, :cost, :category)
        verify_student_timelog_owner!(permitted[:timelog_id].to_i)
        TimeCost.create(timelog_id: permitted[:timelog_id].to_i,
                        cost: permitted[:cost].to_i,
                        category: permitted[:category].to_i)

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
