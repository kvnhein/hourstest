class CreateLiqours < ActiveRecord::Migration
  def change
    create_table :liqours do |t|
      t.string :name
      t.text :description
      t.string :distillery
      t.string :liqour_status
      t.string :liqour_type

      t.timestamps null: false
    end
  end
end
