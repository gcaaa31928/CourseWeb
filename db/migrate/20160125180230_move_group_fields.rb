class MoveGroupFields < ActiveRecord::Migration
    def change
        remove_belongs_to :groups, :student
        add_belongs_to :students, :group
    end
end
