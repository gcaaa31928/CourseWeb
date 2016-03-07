class AddedTimeCostField < ActiveRecord::Migration
    def change
        add_column :time_costs, :id, :primary_key
        add_column :time_costs, :category, :integer
        change_column :time_costs, :id, :integer, before: :student_id
    end
end
