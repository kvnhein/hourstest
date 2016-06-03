class AddBrewLevelToLists < ActiveRecord::Migration
  def change
    add_column :lists, :brew_special, :boolean, :default => true
  end
end
