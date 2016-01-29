class Project < ActiveRecord::Base
    belongs_to :group
    has_many :timelogs
    has_many :scores
end
