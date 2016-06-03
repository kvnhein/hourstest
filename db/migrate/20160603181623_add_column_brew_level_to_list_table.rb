class AddColumnBrewLevelToListTable < ActiveRecord::Migration
  def change
    add_column :lists, :brew_level, :boolean, :default => true
  end
end
