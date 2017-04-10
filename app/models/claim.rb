class Claim < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :event, touch: true
  acts_as_votable
  before_save :default_values
  validates :description, presence: true
  
  def default_values
    self.status ||= 0
    self.delete_date ||= Date.yesterday
 end
 
 def claim_votes
   votes=0
   self.votes_for.up.each do |vote|
     votes = votes + User.find(vote.voter_id).voting_power
   end
   return votes
 end
 
 def self.claims_cached
    Rails.cache.fetch([ "claims"]) { all }
 end
  
 def voter_exp
   votes=0
   self.votes_for.up.each do |vote|
     votes = votes + User.find(vote.voter_id).experience
   end
   return votes
 end
end
