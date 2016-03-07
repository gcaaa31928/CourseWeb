class CreateHomeworks < ActiveRecord::Migration
    def change
        create_table :homeworks do |t|
            t.string :name
            t.belongs_to :course
            t.timestamps null: false
        end
    end
end
