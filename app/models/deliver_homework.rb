class DeliverHomework < ActiveRecord::Base
    belongs_to :homework
    belongs_to :student
end
