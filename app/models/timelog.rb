class Timelog < ActiveRecord::Base
    self.primary_key = :id, :student_id
end
