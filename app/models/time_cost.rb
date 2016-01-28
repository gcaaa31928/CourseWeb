class TimeCost < ActiveRecord::Base
    self.primary_keys = :student_id
    validates :id, uniqueness: {scope: :student_id}
    belongs_to :timelog
    belongs_to :student

end
