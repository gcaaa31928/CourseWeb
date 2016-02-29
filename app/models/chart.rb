class Chart < ActiveRecord::Base
    serialize :average_commits_count
    serialize :high_standard_commits_count
    serialize :low_standard_commits_count
end
