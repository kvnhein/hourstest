class AddUrbanistToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :urbanist, :boolean
  end
end
