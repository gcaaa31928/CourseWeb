require 'securerandom'

class Admin < ActiveRecord::Base
    def self.upsert
        access_token = SecureRandom.uuid.to_s
        access_token.gsub!('-', '')
        if Admin.exists?(0)
            admin = Admin.find(0)
            admin.update(access_token: access_token)
            return admin
        else
            admin = Admin.new(id: 0, access_token: access_token)
            admin.save
            return admin
        end

    end
end
