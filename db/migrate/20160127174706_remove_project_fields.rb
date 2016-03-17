class RemoveProjectFields < ActiveRecord::Migration
    def change
        remove_column :projects, :timelog_id
        add_belongs_to :timelogs, :project
    end
end
