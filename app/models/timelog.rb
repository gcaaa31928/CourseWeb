require 'carrierwave/orm/activerecord'
class Timelog < ActiveRecord::Base
    belongs_to :project
    has_many :time_costs
    mount_uploader :image, TimelogImageUploader
end
