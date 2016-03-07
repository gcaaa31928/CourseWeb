class TimeCost < ActiveRecord::Base
    belongs_to :timelog
    belongs_to :student

end
