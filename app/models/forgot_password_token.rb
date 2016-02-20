class ForgotPasswordToken < ActiveRecord::Base
    belongs_to :student

    def save_with_generate_token!
        access_token = SecureRandom.uuid.to_s
        access_token.gsub!('-', '')
        self.token = access_token
        self.expire_at = Time.now
        self.save!
    end
end
