class CreateTeachingAssistantsPrivileges < ActiveRecord::Migration
    def change
        create_table :teaching_assistants_privileges, id: false do |t|
            t.belongs_to :teaching_assistants
            t.belongs_to :privilege
        end
    end
end
