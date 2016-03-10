class AddedAcceptanceOnTimelog < ActiveRecord::Migration
    def change
        add_column :timelogs, :acceptance, :boolean, :default => false
    end
end
