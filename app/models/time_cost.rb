class TimeCost < ActiveRecord::Base
    self.primary_keys = :student_id, :timelog_id
    # validates :student_id, uniqueness: { scope: [:id] }
    belongs_to :timelog
    belongs_to :student

end
