class UserMailer < ApplicationMailer

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.user_mailer.forgot_password.subject
    #
    def forgot_password()
        @greeting = "Hi"

        mail(to: "gcaaa31928@gmail.com", subject: 'test')
    end
end
