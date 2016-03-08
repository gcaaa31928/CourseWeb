class RefineTimeCostField < ActiveRecord::Migration
    def change
        remove_index :time_costs, ["student_id", "timelog_id"]
        add_index :time_costs, :id, :unique => true
    end
end
