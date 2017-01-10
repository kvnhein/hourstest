class Claim < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  acts_as_votable
  before_save :default_values
  validates :description, presence: true
  
  def default_values
    self.status ||= 0
 end
end
