class CreateCharts < ActiveRecord::Migration
    def change
        create_table :charts do |t|
            t.string 'average_commits_count', array: true
            t.string 'high_standard_commits_count', array: true
            t.string 'low_standard_commits_count', array: true
            t.timestamps null: false
        end
    end
end
