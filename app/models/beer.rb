class Beer < ActiveRecord::Base
  belongs_to :venue
  
  def self.on_draft
    self.beer_status = 1 
  end
  
  def self.on_reserve
    self.beer_status = 2
  end
end
