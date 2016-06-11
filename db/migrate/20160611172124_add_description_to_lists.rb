class AddDescriptionToLists < ActiveRecord::Migration
  def change
    add_column :lists, :beer_description, :text
  end
end
