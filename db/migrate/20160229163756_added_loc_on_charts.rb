class AddedLocOnCharts < ActiveRecord::Migration
    def change
        add_column :charts, :average_loc, :text
        add_column :charts, :high_standard_loc, :text
        add_column :charts, :low_standard_loc , :text
    end
end
