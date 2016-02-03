class AddSomeFieldOnTeachingAssistant < ActiveRecord::Migration
    def change
        rename_column :teaching_assistants, :class, :class_name
        add_belongs_to :teaching_assistants, :course
        add_column :teaching_assistants, :email, :string
    end
end
