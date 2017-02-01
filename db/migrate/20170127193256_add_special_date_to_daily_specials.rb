class AddSpecialDateToDailySpecials < ActiveRecord::Migration
  def change
    add_column :daily_specials, :special_date, :date
  end
end
