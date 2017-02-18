class RemoveNumEventsSavedFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :num_events_saved, :integer
  end
end
