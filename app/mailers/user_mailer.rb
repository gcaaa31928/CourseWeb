class UserMailer < ApplicationMailer

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.user_mailer.forgot_password.subject
    #
    def forgot_password(student_id, token)
        @token = token
        to_address = "t#{student_id}@ntut.edu.tw"
        mail(to: to_address, subject: 'CourseWeb密碼重設通知信')
    end
end
