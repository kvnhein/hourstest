class Event < ActiveRecord::Base
  acts_as_taggable
  acts_as_votable
  by_star_field :created_at
  validates :special, presence: true
  #validates :validate_tag, presence: true

  belongs_to :venue, touch: true
  has_many :claims, dependent: :destroy
  
  before_save :upper_case
  before_save :default_values

  scope :special_like, -> (special) { where("special ilike ?", special)}


 
 def default_values
  self.event_verify ||= Time.now 
  self.varified_user ||= current_user.id
 end

 def upper_case
    self.tag_list.each do |tag|
      tag.capitalize!
    end
 end

 def week_verification
  if self.event_verify
   if self.event_verify < 7.days.ago 
    return true
   end
  else
   return true
  end
 end
 
 def validate_tag
    tag_list.each do |tag|
      # This will only accept two character alphanumeric entry such as A1, B2, C3. The alpha character has to precede the numeric.
      errors.add(:tag_list, "can only have Food, Drinks, Late Nite, Entertainment as tags***") unless ["food","drinks","late nite","entertainment"].include? tag.downcase
    end
 end

 
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

  def new_event
    a = Event.after(Date.today - 7).to_a
    b = Event.after(Date.today - 7, field: :updated_at).to_a
    c = Event.before(Date.today - 30, field: :event_verify).to_a
    if a.include? self
      return "New"
    elsif c.include? self 
     return "Not Verified"
    end
  end


 def claims?
  if Claim.where(event_id: self.id).count > 0 
   return true
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

