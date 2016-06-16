class CreateDailySpecials < ActiveRecord::Migration
  def change
    create_table :daily_specials do |t|
      t.string :text
      t.text :description
      t.string :price
      t.references :venue, index: true, foreign_key: true
      t.string :dish_type

      t.timestamps null: false
    end
  end
end
