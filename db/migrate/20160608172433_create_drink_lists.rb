class CreateDrinkLists < ActiveRecord::Migration
  def change
    create_table :drink_lists do |t|
      t.string :name
      t.text :description
      t.string :price

      t.timestamps null: false
    end
  end
end
