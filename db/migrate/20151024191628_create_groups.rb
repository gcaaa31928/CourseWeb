class CreateGroups < ActiveRecord::Migration
    def change
        create_table :groups do |t|
            t.integer :student_id
            t.integer :project_id
            t.timestamps null: false
        end
    end
end
