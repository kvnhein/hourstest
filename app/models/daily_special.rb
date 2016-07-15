class DailySpecial < ActiveRecord::Base
  validates :text, presence: true
  belongs_to :venue
  acts_as_votable
   def event_type
    Venue.where(id: self.venue_id).first.genre unless Venue.where(id: self.venue_id).first.genre.nil?
   end
  
   def event_venue
     Venue.where(id: self.venue_id).first
   end
end
