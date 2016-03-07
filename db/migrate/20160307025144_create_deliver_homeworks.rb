class CreateDeliverHomeworks < ActiveRecord::Migration
    def change
        create_table :deliver_homeworks do |t|
            t.belongs_to :student
            t.belongs_to :homework
            t.timestamps null: false
        end
    end
end
