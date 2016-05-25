class Event < ActiveRecord::Base
scope :special_like, -> (special) { where("special ilike ?", special)}
  belongs_to :venue

 def event_venue
  Venue.where(id: self.venue_id).first
 end
end

