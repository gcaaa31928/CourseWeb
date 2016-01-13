class AddedProjectField < ActiveRecord::Migration
    def change
        add_column :projects, :timelog_id, :integer
    end
end
