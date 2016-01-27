class AddedRefUrlOnProject < ActiveRecord::Migration
    def change
        add_column :projects, :ref_url, :string
        remove_belongs_to :projects, :timelog
    end
end
