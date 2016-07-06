class Event < ActiveRecord::Base
scope :special_like, -> (special) { where("special ilike ?", special)}
  belongs_to :venue

 def event_venue
  Venue.where(id: self.venue_id).first
 end

  def event_type
    Venue.where(id: self.venue_id).first.genre unless Venue.where(id: self.venue_id).first.genre.nil?
 end

  def any_details
  if self.detail.nil?
    return 1 
  else 
    if self.detail.length < 1
     return 1
    else
     return 2
    end
  end
 end


end

