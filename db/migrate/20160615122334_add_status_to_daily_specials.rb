class AddStatusToDailySpecials < ActiveRecord::Migration
  def change
    add_column :daily_specials, :status, :string
  end
end
