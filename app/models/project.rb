class Project < ActiveRecord::Base
    belongs_to :group
    has_many :timelogs
    has_many :scores

    def can?(student)
        self.group.students.any? do |s|
            s.id == student.id
        end
    end

    def latest_timelog_todo
        timelogs = self.timelogs
        if timelogs
            timelogs = timelogs.order(week_no: :desc)
            timelogs.each do |timelog|
                return timelog.todo unless timelog.todo.nil? or timelog.todo.empty?
            end
        end
        ''
    end

    def latest_timelog
        timelogs = self.timelogs
        if timelogs
            timelogs = timelogs.order(week_no: :desc)
            return timelogs[0].as_json(only:[:id, :acceptance])
        end
        false
    end

    def latest_timelog_image
        timelogs = self.timelogs
        if timelogs
            timelogs = timelogs.order(week_no: :desc)
            timelogs.each do |timelog|
                if timelog.image and timelog.image.path
                    return timelog.image.url
                end
            end
        end
        ''
    end

end
