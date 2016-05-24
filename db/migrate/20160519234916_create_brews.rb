class CreateBrews < ActiveRecord::Migration
  def change
    create_table :brews do |t|
      t.string :name
      t.string :brewery
      t.text :detail
      t.string :abv

      t.timestamps null: false
    end
  end
end
