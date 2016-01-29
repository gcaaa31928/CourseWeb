class ChangeRelationWithProjectAndScore < ActiveRecord::Migration
    def change
        remove_belongs_to :projects, :score
        add_belongs_to :scores, :project
    end
end
