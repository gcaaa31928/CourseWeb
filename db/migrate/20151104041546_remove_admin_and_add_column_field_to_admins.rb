class RemoveAdminAndAddColumnFieldToAdmins < ActiveRecord::Migration
    def change
        drop_table :admin
        add_column :admins, :access_token, :string
    end
end
