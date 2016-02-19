class AddedForgotPasswordToken < ActiveRecord::Migration
    def change
        create_table :forgot_password_tokens do |t|
            t.belongs_to :student
            t.string :token
            t.datetime :expire_at
        end
    end
end
