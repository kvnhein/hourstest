class Venue < ActiveRecord::Base

  geocoded_by :address
  after_validation :geocode
  by_star_field :venue_verify
  before_save :default_values
  def default_values
    self.owner ||= 1
    self.venue_verify ||= Time.now
  end

  
 
  def varified_array
    a = 7.day.ago
    b = time.now
    self.between_times(a,b)
  end

  belongs_to :neighborhood
  has_many :events, dependent: :destroy
  has_many :daily_specials, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :bees

  def to_param
    "#{id} #{name}".parameterize
  end
  
  def venue_area
     "#{name} | #{Neighborhood.find(neighborhood_id).name}"
  end

  def feature_dish_check
    a = self.id
    b = DailySpecial.where(venue_id: a).today.count
  end
  def venue_type
    self.genre unless self.genre.nil?
  end
  def self.all_cached
    Rails.cache.fetch([ "venues"]) { all }
  end
  
  def self.downtown_venues
    Rails.cache.fetch('downotown_venues') {Neighborhood.find(5).venues}
  end 


  def avg_time
    events = self.events
    avg_time = (events.map {|event| event.event_verify }.map{|date| (Time.current - date).to_i/(24*60*60)}.inject(0){|sum,x| sum + x })/events.count
    self.avg_verify = avg_time
    self.save!
  end 

   def total_votes(todays_events)
      events = todays_events.select { |event| event.venue_id == self.id } 
      total_votes = events.map {|event| event.cached_votes_total }.inject(0){|sum,x| sum + x }
      return total_votes
    end 
  
  def order_todays_venues(todays_events, venues)
    x=[]
    todays_events.each do |event|
	    x.push(event.venue_id)
	  end
    venue_ids = x.uniq
    todays_venues = venues.select {|venue| venu_ids.include?(venue.id)}.sort! {|x,y| y.total_votes(todays_events) <=> x.total_votes(todays_events)}
   end 
  
  
  def venue_avg_verify
    days = 0
    Event.where(venue_id: self.id, day: Time.current.strftime("%A")).each do |event| 
      if event.event_verify
        days = days + (Time.current - event.event_verify).to_i/(24*60*60)
      else
        days = days + (Time.current - event.created_at).to_i/(24*60*60)
      end
    end
    if Event.where(venue_id: self.id,day: Time.current.strftime("%A")).count > 0
      self.avg_verify = days/Event.where(venue_id: self.id,day: Time.current.strftime("%A")).count
      self.save 
    else
      self.avg_verify = 0 
      self.save
    end
  end
  
  
  



end
