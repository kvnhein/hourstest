class AddSprToDrinks < ActiveRecord::Migration
  def change
    add_column :drinks, :spr, :integer
  end
end
