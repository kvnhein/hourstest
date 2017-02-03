class AddUserIdToDailySpecials < ActiveRecord::Migration
  def change
    add_column :daily_specials, :user_id, :integer
  end
end
