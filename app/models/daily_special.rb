class DailySpecial < ActiveRecord::Base
  acts_as_taggable
  validates :text, presence: true
  belongs_to :venue
  acts_as_votable
  before_save :default_values

  has_attached_file :image,
  styles: { :medium => {:geometry => "500x500^", :quality => 100} , thumb: "100x100>" }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

 def default_values
    self.credit ||= 0
 end
  def event_type
    Venue.where(id: self.venue_id).first.genre unless Venue.where(id: self.venue_id).first.genre.nil?
   end

   def event_venue
     Venue.where(id: self.venue_id).first
   end

   def special_count
     self.today.count
   end

end
