class Event < ActiveRecord::Base
  attr_accessor :special
  validates :special, presence: true
  belongs_to :venue
  
  
end 
 
