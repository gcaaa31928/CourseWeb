class Timelog < ActiveRecord::Base
    belongs_to :project
    has_many :time_costs
end
