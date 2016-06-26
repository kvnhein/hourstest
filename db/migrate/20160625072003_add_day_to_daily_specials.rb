class AddDayToDailySpecials < ActiveRecord::Migration
  def change
    add_column :daily_specials, :day, :string
  end
end
