class RenameProjectFileds < ActiveRecord::Migration
    def change
        rename_column :projects, :type, :project_type
    end
end
