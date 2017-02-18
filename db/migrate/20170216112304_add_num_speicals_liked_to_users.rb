class AddNumSpeicalsLikedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :num_features_liked, :integer
  end
end
