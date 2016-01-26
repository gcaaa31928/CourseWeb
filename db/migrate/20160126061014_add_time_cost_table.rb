class AddTimeCostTable < ActiveRecord::Migration
    def change
        create_table :time_costs, {:id => false} do |t|
            t.integer :id
            t.belongs_to :student
            t.integer :cost
            t.timestamps null: false
        end
    end
end
