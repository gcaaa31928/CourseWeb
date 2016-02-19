require 'http_status_code'
class Api::StudentController < ApplicationController

    # deprecated
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


    def list_without_group
        retrieve
        permitted = params.permit(:course_id)
        if @student and not same_course?(permitted[:course_id].to_i)
            raise '你沒有權限執行這個操作'
        end
        students = Student.where(group_id: nil)
        students.order!(:id)
        render HttpStatusCode.ok(students.as_json(only: [:id, :name]))
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end



    private


    def same_course?(course_id)
        @student.course_id == course_id
    end

    def retrieve
        require_headers
        retrieve_student
        retrieve_admin
        if @student.nil? and @teaching_assistant.nil? and @admin.nil?
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
