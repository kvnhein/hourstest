class AddVenueToLiqours < ActiveRecord::Migration
  def change
    add_reference :liqours, :venue, index: true, foreign_key: true
  end
end
