class Event < ActiveRecord::Base
scope :special_like, -> (special) { where("special ilike ?", special)}
  belongs_to :venue

 
end

