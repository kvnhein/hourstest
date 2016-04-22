class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :address
      t.float :longitude
      t.float :latitude
      t.references :neighborhood, index: true, foreign_key: true
      t.integer :owner

      t.timestamps null: false
    end
  end
end
