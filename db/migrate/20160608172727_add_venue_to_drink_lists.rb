class AddVenueToDrinkLists < ActiveRecord::Migration
  def change
    add_reference :drink_lists, :venue, index: true, foreign_key: true
  end
end
