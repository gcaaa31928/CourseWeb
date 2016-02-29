class AddedFieldOnCharts < ActiveRecord::Migration
    def change
        add_belongs_to :charts, :course
    end
end
