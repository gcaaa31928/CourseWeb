class ChangeImageColumnOnTimelog < ActiveRecord::Migration
    def change
        change_column :timelogs, :image, :string
    end
end
