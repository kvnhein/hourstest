class AddEventVerifyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :event_verify, :datetime
  end
end
