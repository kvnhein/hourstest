class AddSprToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :spr_rank, :integer
  end
end
