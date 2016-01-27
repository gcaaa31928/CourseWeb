class ChangedRelationWithProjectAndGroup < ActiveRecord::Migration
    def change
        remove_belongs_to :groups, :project
        add_belongs_to :projects, :group
    end
end
