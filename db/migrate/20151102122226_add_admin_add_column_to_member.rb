class AddAdminAddColumnToMember < ActiveRecord::Migration
    def change
        create_table :admin do |t|
            t.string :name
            t.string :access_token
        end
        add_column :students, :access_token, :string
        add_column :teaching_assistants, :access_token, :string
    end
end
