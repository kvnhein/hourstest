class DailySpecial < ActiveRecord::Base
  validates :text, presence: true
  belongs_to :venue
  acts_as_votable

  has_attached_file :image, styles: { :medium => {:geometry => "500x500>", :quality => 100} , thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
   def event_type
    Venue.where(id: self.venue_id).first.genre unless Venue.where(id: self.venue_id).first.genre.nil?
   end

   def event_venue
     Venue.where(id: self.venue_id).first
   end

  
end
