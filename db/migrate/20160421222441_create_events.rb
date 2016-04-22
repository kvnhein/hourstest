class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :special
      t.string :day
      t.references :venue, index: true, foreign_key: true
      t.float :start
      t.float :end

      t.timestamps null: false
    end
  end
end
