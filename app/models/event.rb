class Event < ActiveRecord::Base
  acts_as_taggable
  validates :special, presence: true
scope :special_like, -> (special) { where("special ilike ?", special)}
  belongs_to :venue
acts_as_votable
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

