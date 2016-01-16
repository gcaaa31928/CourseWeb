class RenameStudentClassField < ActiveRecord::Migration
    def change
        rename_column(:students, :class, :class_name)
    end
end
