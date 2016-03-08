class TimeCost < ActiveRecord::Base
    belongs_to :timelog
    belongs_to :student

    def can_destroy?(student)
        students = self.timelog.project.group.students
        students.each do |s|
            if student.id == s.id
                return true
            end
        end
        false
    end
end
