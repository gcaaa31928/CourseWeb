class CreateScores < ActiveRecord::Migration
    def change
        create_table :scores do |t|
            t.belongs_to :teaching_assistant
            t.integer :point
            t.integer :no
            t.timestamps null: false
        end
    end
end
