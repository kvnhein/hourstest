class Event < ActiveRecord::Base
  acts_as_taggable
  acts_as_votable
  by_star_field :created_at
  validates :special, presence: true
  validates :day, presence: true
  #validates :validate_tag, presence: true

  belongs_to :venue, touch: true
  has_many :claims, dependent: :destroy
  has_many :reviews, dependent: :destroy
  
  before_save :upper_case
  before_save :default_values

  scope :special_like, -> (special) { where("special ilike ?", special)}

def claim_count(claims)
    total_claim = claims.select{|claim| claim.event_id == self.id}
    return total_claim.count
     
 end
 
 
 def average_rating
  reviews.count == 0 ? 0 : reviews.average(:star).round(2)
 end 
 
 def find_tags
        tags = []
        tags.push("Food") if self.food == true
        tags.push("Drinks") if self.drinks == true
        tags.push("Late Nite") if self.late_nite == true
        tags.push("Entertainment") if self.entertainment == true
        return tags
 end 
 

 def find_event_user(users)
  event_user = users.select {|user| user.id == self.user_id}
  return event_user.first
 end 

def find_event_user_varified(users)
  event_user_varified = users.select {|user| user.id == self.varified_user}
  return event_user_varified.first
end
 def self.all_cached
  Rails.cache.fetch('events') { all }
 end
def cached_special
 Rails.cache.fetch([self, "special"]) {special}
end
def self.new_events_cached
 Rails.cache.fetch('new_events') { after(Date.today - 7, field: :updated_at)}
end


def self.likes_cached
end
 def default_values
  self.event_verify ||= Time.now 
  self.varified_user ||= current_user.id
  self.credits ||= 0 
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
    
      if self.legit_hour == true 
       return "Verified"
      else 
       return "New"
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

def color_chip(current_hour, current_minute)
	if current_hour-2+(current_minute.to_f*0.0166) > self.start.to_i && current_hour-2+(current_minute.to_f*0.0166) < self.end.to_f
		style="background-color:#17a787"
	elsif current_hour < 1 && self.end < 23 &&  self.end > 22
		style="background-color:#17a787"
    elsif current_hour < 2 && self.end < 24  &&  self.end > 23
		style="background-color:#17a787"
	elsif current_hour-2+(@c.to_f*0.0166) < self.start && current_hour > 2
		style="background-color:#000000"
	else
		style="background-color:#bdbdbd"
    end
end

def event_now(current_hour, current_minute)
 if current_hour-2+(current_minute.to_f*0.0166) > self.start.to_i && current_hour-2+(current_minute.to_f*0.0166) < self.end.to_f
		 return true
	elsif current_hour < 1 && self.end < 23 &&  self.end > 22
	  return true
 elsif current_hour < 2 && self.end < 24  &&  self.end > 23
		 return true
	else 
		 return false
		end
end

def event_later(current_hour, current_minute)
 if current_hour-2+(@c.to_f*0.0166) < self.start && current_hour > 2
		 return true
	else 
		 return false
	end
end

def event_past(current_hour, current_minute)
 if self.event_now(current_hour, current_minute) == false && self.event_later(current_hour, current_minute) == false
  return true
 else 
  return false
 end
end

def update_tags
 tags = self.tag_list
 if tags.include? ("Food")
  self.food = true
  self.save!
 else
  self.food = false
  self.save!
 end
 
 if tags.include? ("Drinks")
  self.drinks = true
  self.save!
 else
  self.drinks = false
  self.save!
 end 
 
 if tags.include? ("Late Nite")
  self.late_nite = true
  self.save!
 else
  self.late_nite = false
  self.save!
 end
 
 if tags.include? ("Entertainment")
  self.entertainment = true
  self.save!
 else
  self.entertainment = false
  self.save!
 end
end


end

