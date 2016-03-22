class Project < ActiveRecord::Base
    belongs_to :group
    has_many :timelogs
    has_many :scores

    def can?(student)
        self.group.students.any? do |s|
            s.id == student.id
        end
    end

    

    def second_last_timelog
        timelogs = self.timelogs
        if timelogs and timelogs.count > 1
            timelogs = timelogs.order!(week_no: :desc)
            return timelogs[0].as_json(only:[:todo, :image, :acceptance, :id])
        end
        nil
    end

end
