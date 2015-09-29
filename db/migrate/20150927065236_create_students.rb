class CreateStudents < ActiveRecord::Migration
    def change
        create_table :students do |t|
            t.string :email
            t.string :password
            t.boolean :require_change_password
            t.timestamps null: false
        end
    end
end
