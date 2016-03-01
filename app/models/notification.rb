class Notification < ActiveRecord::Base

    def self.send_message(text)
        Notification.create(text: text)
    end

    def self.student_action(student, action)
        self.send_message("#{student.name} 正在#{action}")
    end
end
