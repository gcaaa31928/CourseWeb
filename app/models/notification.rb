class Notification < ActiveRecord::Base

    def self.send_message(text)
        Notification.create(text: text)
    end

    def self.student_action(student, action)
        notification = Notification.last
        if Time.now - notification.created_at >= 1.second
            self.send_message("#{student.name} 正在#{action}")
        end
    end
end
