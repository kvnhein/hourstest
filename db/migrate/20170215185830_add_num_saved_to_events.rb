class AddNumSavedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :num_events_saved, :integer
  end
end
