class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :daily_special, index: true, foreign_key: true
      t.integer :credit

      t.timestamps null: false
    end
  end
end
