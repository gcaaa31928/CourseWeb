class AddedIndexOnTimeCost < ActiveRecord::Migration
    def change
        add_index :time_costs, ["id", "student_id"], :unique => true
        execute "ALTER TABLE words ADD PRIMARY KEY (id,student_id);"
    end
end
