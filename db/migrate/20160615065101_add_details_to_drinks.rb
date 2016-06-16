class AddDetailsToDrinks < ActiveRecord::Migration
  def change
    add_column :drinks, :name, :string
    add_column :drinks, :description, :text
    add_column :drinks, :price, :string
    add_column :drinks, :drink_Status, :string
    add_column :drinks, :drink_type, :string
    add_reference :drinks, :venue, index: true, foreign_key: true
  end
end
