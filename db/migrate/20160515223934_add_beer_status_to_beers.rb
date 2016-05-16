class AddBeerStatusToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :beer_status, :integer
  end
end
