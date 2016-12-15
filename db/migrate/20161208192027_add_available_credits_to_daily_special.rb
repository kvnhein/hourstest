class AddAvailableCreditsToDailySpecial < ActiveRecord::Migration
  def change
    add_column :daily_specials, :available_credits, :integer
  end
end
