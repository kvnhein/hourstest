class AddCheckinToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :venue_verify, :datetime
  end
end
