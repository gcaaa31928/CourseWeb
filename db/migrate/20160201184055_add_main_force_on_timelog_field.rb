class AddMainForceOnTimelogField < ActiveRecord::Migration
    def change
        add_column :timelogs, :main_force, :integer
    end
end
