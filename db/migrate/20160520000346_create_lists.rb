class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.references :venue, index: true, foreign_key: true
      t.references :brew, index: true, foreign_key: true
      t.string :serving_style
      t.string :serving_size
      t.string :price
      t.string :status

      t.timestamps null: false
    end
  end
end
