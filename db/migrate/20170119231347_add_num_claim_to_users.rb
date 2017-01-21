class AddNumClaimToUsers < ActiveRecord::Migration
  def change
    add_column :users, :num_event_votes, :integer
    add_column :users, :num_claim_votes, :integer
  end
end
