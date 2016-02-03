class AddSomeFieldOnTeachingAssistant < ActiveRecord::Migration
    def change

        add_column :teaching_assistants, :class_name, :string
        # add_belongs_to :teaching_assistants, :course
        add_column :teaching_assistants, :email, :string
    end
end
