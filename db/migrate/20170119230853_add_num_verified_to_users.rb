class AddNumVerifiedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :num_verified, :integer
  end
end
