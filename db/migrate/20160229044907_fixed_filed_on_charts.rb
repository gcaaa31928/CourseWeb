class FixedFiledOnCharts < ActiveRecord::Migration
    def change
        remove_column :charts, :average_commits_count
        remove_column :charts, :high_standard_commits_count
        remove_column :charts, :low_standard_commits_count

        add_column :charts, :average_commits_count, :text
        add_column :charts, :high_standard_commits_count, :text
        add_column :charts, :low_standard_commits_count, :text

    end
end
