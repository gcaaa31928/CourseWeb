class AddTimelogField < ActiveRecord::Migration
    def change
        add_column :timelogs, :image, :text
    end
end
