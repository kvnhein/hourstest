class AddFoodToEvents < ActiveRecord::Migration
  def change
    add_column :events, :food, :boolean
    add_column :events, :drinks, :boolean
    add_column :events, :late_nite, :boolean
    add_column :events, :entertainment, :boolean
  end
end
