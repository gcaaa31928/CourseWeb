class CreateTimelogs < ActiveRecord::Migration
    def change
        create_table :timelogs do |t|
            t.integer :week_no
            t.date :date
            t.integer :personal_time_cost
            t.integer :group_time_cost
            t.string :todo
            t.integer :category
            t.timestamps null: false
        end
    end
end
