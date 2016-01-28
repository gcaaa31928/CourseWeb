class AddProjectOnTimelog < ActiveRecord::Migration
    def change
        add_belongs_to :timelogs, :project
    end
end
