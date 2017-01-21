class Claim < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  acts_as_votable
  before_save :default_values
  validates :description, presence: true
  
  def default_values
    self.status ||= 0
 end
 
 def claim_votes
   votes=0
   self.votes_for.up.each do |vote|
     votes = votes + User.find(vote.voter_id).voting_power
   end
   return votes
 end
end
