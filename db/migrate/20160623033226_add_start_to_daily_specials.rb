class AddStartToDailySpecials < ActiveRecord::Migration
  def change
    add_column :daily_specials, :start, :float
    add_column :daily_specials, :end, :float
  end
end
