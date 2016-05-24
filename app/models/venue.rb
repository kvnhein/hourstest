class Venue < ActiveRecord::Base

  geocoded_by :address
  after_validation :geocode

  before_save :default_values
  def default_values
    self.owner ||= 1
    self.venue_verify ||= Time.now
  end

  belongs_to :neighborhood
  has_many :events
  has_many :beers
end
