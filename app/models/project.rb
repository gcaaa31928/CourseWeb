class Project < ActiveRecord::Base
    belongs_to :group
    has_many :timelogs
    has_many :scores

    def can?(student)
        self.group.students.any? do |s|
            s.id == student.id
        end
    end
end
