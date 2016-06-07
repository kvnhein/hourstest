class AddVenueGenreToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :genre, :string
  end
end
