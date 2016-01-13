class CreateStudents < ActiveRecord::Migration
    def change
        drop_table :students
        create_table :students do |t|
            t.string :name
            t.string :class
            t.belongs_to :course
            t.timestamps null: false
        end
    end
end
