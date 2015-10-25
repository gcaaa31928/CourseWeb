class AddedProjectField < ActiveRecord::Migration
    def change
        add_column :project, timelog_id, :integer
    end
end
