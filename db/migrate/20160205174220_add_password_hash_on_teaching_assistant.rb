class AddPasswordHashOnTeachingAssistant < ActiveRecord::Migration
    def change
        add_column :teaching_assistants, :password_hash, :string
    end
end
