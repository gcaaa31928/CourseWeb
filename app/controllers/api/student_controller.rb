require 'http_status_code'
class Api::StudentController < ApplicationController

    def login
        permitted = params.permit(:id, :password)
        permitted[:password] = Base64.decode64(permitted[:password])
        student = Student.find(permitted[:id])
        if student.nil?
            return render HttpStatusCode.forbidden(
                {
                    errorMsg: 'id or password is not correct'
                })
        end
        if student.password == permitted[:password]
            token = student.generate_token_and_update
            return render HttpStatusCode.ok(
                {
                    accessToken: token
                })
        end
        render HttpStatusCode.forbidden(
            {
                errorMsg: 'id or password is not correct'
            })
    end



    private

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end

end
