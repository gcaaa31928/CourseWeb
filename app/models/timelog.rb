class Timelog < ActiveRecord::Base
    belongs_to :project
    has_one :time_cost
end
