class AddNumSavedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :num_events_saved, :integer
  end
end
