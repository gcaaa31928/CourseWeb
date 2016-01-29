class AddedCourseOnGroup < ActiveRecord::Migration
    def change
        add_belongs_to :groups, :course
    end
end
