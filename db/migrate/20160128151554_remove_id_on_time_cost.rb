class RemoveIdOnTimeCost < ActiveRecord::Migration
    def change
        remove_column :time_costs, :id
        add_index :time_costs, ["student_id", "timelog_id"], :unique => true
        execute "ALTER TABLE time_costs ADD PRIMARY KEY (student_id, timelog_id);"
    end
end