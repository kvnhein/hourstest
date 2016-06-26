class DailySpecial < ActiveRecord::Base
  belongs_to :venue

   def event_type
    Venue.where(id: self.venue_id).first.genre unless Venue.where(id: self.venue_id).first.genre.nil?
   end
  
   def event_venue
     Venue.where(id: self.venue_id).first
   end
end
