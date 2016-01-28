class Group < ActiveRecord::Base
    has_one :project
    has_many :students
end
