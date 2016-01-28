class ChangeRelationWithTimeCostAndTimelog < ActiveRecord::Migration
    def change
        remove_belongs_to :timelogs, :time_cost
        add_belongs_to :time_costs, :timelog
    end
end
