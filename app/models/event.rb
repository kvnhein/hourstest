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


 def self.all_cached
  Rails.cache.fetch('events') { all }
 end

 def self.credit_cached
  Rails.cache.fetch('Event.all') { all }
end

def self.likes_cached
end
 def default_values
  self.event_verify ||= Time.now 
  self.varified_user ||= current_user.id
 end
 
 def cached_event_count
  Rails.cache.fetch([self,'number_of_events']) { count }
 end
 
 
 def add_tags
  if self.food == false    
        self.tag_list.remove("Food")
    elsif self.food == true 
        self.tag_list.add("Food")
    end
    if self.drinks == false    
        self.tag_list.remove("Drinks")
    elsif self.drinks == true 
        self.tag_list.add("Drinks")
    end
    if self.late_nite == false    
        self.tag_list.remove("Late nite")
    elsif self.late_nite == true 
        self.tag_list.add("Late nite")
    end
    if self.entertainment == false    
        self.tag_list.remove("Entertainment")
    elsif self.entertainment == true 
        self.tag_list.add("Entertainment")
    end
    self.save!
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
    Venue.all_cached.where(id: self.venue_id).first.genre unless Venue.all_cached.where(id: self.venue_id).first.genre.nil?
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
    c = Event.before(Date.today - 60, field: :event_verify).to_a
    if a.include? self
      if self.legit_hour == true 
       return "Verified"
      else 
       return "New"
     end
    elsif c.include? self 
     return "Not Verified"
    end
  end
  
  def cached_new_event
   Rails.cache.fetch([self, "new_event"], expires_in: 24.hours) {new_event}
  end
  
  
 
 def super_vote?
  voters = self.votes_for.up.by_type(User).voters
  voters.each do |voter|
   if voter.experience > 10000
    return true
   end
  end 
 end 
 
 def legit_hour?
   if self.created_at > "Sat, 04 Mar 2017".to_date
    if self.legit_hour = true
      return true
    elsif self.votes_for.up.count >= 10
      self.legit_hour = true
      self.save!
      voters = self.votes_for.up.by_type(User).voters
      voters.each do |voter|
       voter.experience = voter.experience + 30 
      end 
      self.user.experience = self.user.experience + 60 
    elsif self.created_at  < 1.week.ago && self.legit_hour == false
       self.destroy!
    end
   end
 end 

 def claims?
  if Claim.where(event_id: self.id).count > 0 
   return true
  end
 end
 
 def cached_claims?
  Rails.cache.fetch([self, "claims?"]) {claims?}
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

def next_monday
 date = Date.today
 date += 1 + ((0-date.wday) % 7)
 if self.event_date == date
  return true
 end
end 
def next_tuesday
 date = Date.today
 date += 1 + ((1-date.wday) % 7)
 if self.event_date == date
  return true
 end
end 
def next_wednesday
 date = Date.today
 date += 1 + ((2-date.wday) % 7)
 if self.event_date == date
  return true
 end
end 
def next_thursday
 date = Date.today
 date += 1 + ((3-date.wday) % 7)
 if self.event_date == date
  return true
 end
end 

def next_friday
 date = Date.today
 date += 1 + ((4-date.wday) % 7)
 if self.event_date == date
  return true
 end
end 

def next_saturday
 date = Date.today
 date += 1 + ((5-date.wday) % 7)
 if self.event_date == date
  return true
 end
end 

def next_sunday
 date = Date.today
 date += 1 + ((6-date.wday) % 7)
 if self.event_date == date
  return true
 end
end 

end

