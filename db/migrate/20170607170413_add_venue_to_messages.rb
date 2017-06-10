class AddVenueToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :venue, index: true, foreign_key: true
  end
end
