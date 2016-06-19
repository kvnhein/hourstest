class AddDishStatusToDailySpecials < ActiveRecord::Migration
  def change
    add_column :daily_specials, :dish_status, :string
  end
end
