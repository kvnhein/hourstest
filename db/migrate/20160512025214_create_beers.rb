class CreateBeers < ActiveRecord::Migration
  def change
    create_table :beers do |t|
      t.string :name
      t.string :brewery
      t.string :abv
      t.string :type
      t.string :price
      t.string :serving
      t.text :details
      t.references :venue, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
