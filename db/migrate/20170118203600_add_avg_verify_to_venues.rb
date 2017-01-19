class AddAvgVerifyToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :avg_verify, :integer
  end
end
