class CreateTeachingAssistants < ActiveRecord::Migration
    def change
        create_table :teaching_assistants do |t|
            t.string :name
            t.integer :course_id
            t.timestamps null: false
        end
    end
end
