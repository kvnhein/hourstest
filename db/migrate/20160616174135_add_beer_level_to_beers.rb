class AddBeerLevelToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :beer_level, :integer
  end
end
