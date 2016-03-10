class CreateRollCalls < ActiveRecord::Migration
    def change
        create_table :roll_calls do |t|
            t.integer :period
            t.date :date
            t.belongs_to :student
            t.timestamps null: false
        end
    end
end
