class DailySpecial < ActiveRecord::Base
  acts_as_taggable
  acts_as_votable

  validates :text, presence: true
  validates :price, presence: true
  belongs_to :venue

  before_save :default_values
  before_save :upper_case

  has_attached_file :image,
  styles: { :medium => {:geometry => "500x500^", :quality => 100} , thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/


 def default_values
    self.credit ||= 0
 end
  def event_type
    Venue.where(id: self.venue_id).first.genre unless Venue.where(id: self.venue_id).first.genre.nil?
   end

   def upper_case
    self.tag_list.each do |tag|
      tag.capitalize!
    end
 end

  def special_neighborhood
   Neighborhood.find(Venue.where(id: self.venue_id).first.neighborhood_id).name
  end

   def event_venue
     Venue.where(id: self.venue_id).first
   end

   def special_count
     self.today.count
   end

  def time_conversion
  start_minutes = "00"
  if self.start%1 > 0
    start_minutes = "30"
  end

  start_am = "am"
  if self.start >9.5 && self.start < 22
   start_am = "pm"
  end

  end_minutes = "00"
  if self.end%1 > 0
   end_minutes = "30"
  end

  end_am = "am"
  if self.end.to_f >9.5 && self.end < 22
    end_am="pm"
  end

    #Convert to regular time
  start_time = 0
  end_time = 0
  if self.start.to_f > 10.5
    start_time = (self.start - 0.1).round(0)- 10
  else
    start_time = (self.start - 0.1).round(0)+ 2
  end

  if self.end > 22.5
   end_time = (self.end - 0.1).round(0)- 22
  elsif self.end > 10.5
   end_time = (self.end - 0.1).round(0)- 10
  else
   end_time = (self.end - 0.1).round(0)+ 2
  end

    return "#{start_time}:#{start_minutes} #{start_am} - #{end_time}:#{end_minutes} #{end_am}"

  end

end
