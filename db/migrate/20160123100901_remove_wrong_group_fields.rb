class RemoveWrongGroupFields < ActiveRecord::Migration
    def change
        remove_column :groups, :student_id
        # remove_column :groups, :project_id
        # add_belongs_to :groups, :project
        add_belongs_to :students, :group
    end
end
