class AddPasswordHashFieldToStudent < ActiveRecord::Migration
    def change
        add_column :students, :password_hash, :string
        add_column :students, :email, :string
    end
end
