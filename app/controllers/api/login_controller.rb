class Api::LoginController < ApplicationController


    def login
        permitted = params.permit(:account, :password)
        permitted[:password] = Base64.decode64(permitted[:password])
        # for admin permission
        if permitted[:account] == 'wkchen' and permitted[:password] == 'oopcourse'
            admin = Admin.update_access_token
            return render HttpStatusCode.ok(
                {
                    accessToken: admin.access_token,
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
                        accessToken: token,
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
                        accessToken: token,
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

    private

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end
end
