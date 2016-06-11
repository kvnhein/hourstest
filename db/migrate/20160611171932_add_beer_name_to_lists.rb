class AddBeerNameToLists < ActiveRecord::Migration
  def change
    add_column :lists, :beer_name, :string
  end
end
