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
  has_many :events
  has_many :beers
end
