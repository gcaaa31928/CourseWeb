class ChangeTaPrivilege < ActiveRecord::Migration
    def change
        remove_reference :teaching_assistants_privileges, :teaching_assistants
        add_reference :teaching_assistants_privileges, :teaching_assistant
    end
end
