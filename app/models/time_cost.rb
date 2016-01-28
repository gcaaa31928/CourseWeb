class TimeCost < ActiveRecord::Base
    validates_uniqueness_of :id, scope: [:student_id]
    belongs_to :timelog
    belongs_to :student

end
