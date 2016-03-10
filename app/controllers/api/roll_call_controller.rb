class Api::RollCallController < ApplicationController

    def add
        retrieve
        permitted = params.permit(:period, :date, :student_id)
        date = DateTime.rfc2822(permitted[:date])
        RollCall.create(period: permitted[:period],
                        date: date,
                        student_id: permitted[:student_id].to_i)
        render HttpStatusCode.ok
    end




    private

    def retrieve
        require_headers
        retrieve_student
        retrieve_admin
        if @teaching_assistant.nil? and @admin.nil?
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
