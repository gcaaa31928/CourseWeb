class Api::LoginController < ApplicationController


    def login
        permitted = params.permit(:account, :password)
        permitted[:password] = Base64.decode64(permitted[:password])
        # for admin permission
        if permitted[:account] == 'wkchen' and permitted[:password] == 'oopcourse'
            admin = Admin.update_access_token
            return render HttpStatusCode.ok(
                {
                    info: admin.as_json(only: [:access_token]),
                    type: 'admin'
                }
            )
        end
        teaching_assistant = TeachingAssistant.find_by(id: permitted[:account])
        unless teaching_assistant.nil?
            if teaching_assistant.password == permitted[:password]
                token = teaching_assistant.generate_token_and_update
                return render HttpStatusCode.ok(
                    {
                        info: teaching_assistant.as_json(only: [:id , :access_token, :course_id]),
                        type: 'ta'
                    }
                )
            end
        end
        student = Student.find_by(id: permitted[:account])
        unless student.nil?
            if student.password == permitted[:password]
                token = student.generate_token_and_update
                return render HttpStatusCode.ok(
                    {
                        info: student.as_json(only: [:id , :access_token, :course_id]),
                        type: 'student'
                    }
                )
            end
        end
        render HttpStatusCode.forbidden(
            {
                errorMsg: 'id or password is not correct'
            }
        )
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden
    end

    def verify_access_token
        retrieve
        if @admin or @student or @teaching_assistant
            return render HttpStatusCode.ok
        end
        render HttpStatusCode.forbidden
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden
    end

    private

    def retrieve
        require_headers
        retrieve_student
        retrieve_admin

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
