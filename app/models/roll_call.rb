class RollCall < ActiveRecord::Base
    belongs_to :student
    attr_accessor :by_date

    def get_by_date(date = nil)
        date ||= @by_date
    end
end
