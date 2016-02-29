class Chart < ActiveRecord::Base
    serialize :average_commits_count
    serialize :high_standard_commits_count
    serialize :low_standard_commits_count
    serialize :average_loc
    serialize :high_standard_loc
    serialize :low_standard_loc
end
