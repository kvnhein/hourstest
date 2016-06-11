class AddAbvToLists < ActiveRecord::Migration
  def change
    add_column :lists, :beer_abv, :string
  end
end
