class AddCreditsTodailySpecials < ActiveRecord::Migration
  def change
     add_column :daily_specials, :credit, :integer
  end
end
