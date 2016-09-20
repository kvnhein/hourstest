class Neighborhood < ActiveRecord::Base
  has_many :venues

  def cached_venue_count
    Rails.cache.fetch([self, "venue_count" ]) {venues}
  end

  
  def cached_neighborhood(id)
    Rails.cache.fetch("downtown_venues#{id}") do
      self.find(id).venues.order("name ASC")
   end
  end
end
