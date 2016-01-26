class AddTimeCostFieldOnTimelog < ActiveRecord::Migration
    def change
        remove_column :timelogs, :group_time_cost
        add_belongs_to :timelogs, :time_cost
    end
end
