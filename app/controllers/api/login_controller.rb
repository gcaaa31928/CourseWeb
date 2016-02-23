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
                        info: teaching_assistant.as_json(only: [:id, :access_token, :course_id]),
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
                        info: student.as_json(only: [:id, :access_token, :course_id]),
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

    def reset_password
        retrieve
        permitted = params.permit(:password)
        permitted[:password] = Base64.decode64(permitted[:password])
        if @student
            @student.password = permitted[:password]
            @student.save!
        elsif @teaching_assistant
            @teaching_assistant.password = permitted[:password]
            @teaching_assistant.save!
        elsif @admin
            raise '請勿更動admin的密碼'
        end
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def verify_student_access_token
        retrieve
        if @student
            return render HttpStatusCode.ok
        end
        render HttpStatusCode.forbidden
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def verify_admin_access_token
        retrieve
        if @admin or @teaching_assistant
            return render HttpStatusCode.ok
        end
        render HttpStatusCode.forbidden
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def forgot_password
        permitted = params.permit(:student_id)
        student_id = permitted[:student_id].to_i
        student = Student.find_by(id: student_id)
        teaching_assistant = TeachingAssistant.find_by(id: student_id)
        if student.nil? and teaching_assistant.nil?
            raise '沒有此帳號'
        end
        forgot_password_token = ForgotPasswordToken.new(student_id: permitted[:student_id].to_i)
        forgot_password_token.save_with_generate_token!
        UserMailer.forgot_password(forgot_password_token.student_id, forgot_password_token.token).deliver_later
        render HttpStatusCode.ok
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def reset_password_by_token
        permitted = params.permit(:token, :password)
        permitted[:password] = Base64.decode64(permitted[:password])
        forgot_password_token = ForgotPasswordToken.find_by(token: permitted[:token])
        if forgot_password_token.nil?
            raise '已經被設定過了'
        end
        if Time.now - forgot_password_token.expire_at > 10.minutes
            raise '已經過期了，請重新發送email'
        end
        ForgotPasswordToken.transaction do
            forgot_password_token.destroy
            student = forgot_password_token.student
            teaching_assistant = TeachingAssistant.find_by(id: forgot_password_token.student_id)
            if student
                student.password = permitted[:password]
                student.save!
            elsif teaching_assistant
                teaching_assistant.password = permitted[:password]
                teaching_assistant.save!
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
