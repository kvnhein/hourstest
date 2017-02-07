class AddOpenTableToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :open_table_id, :string
  end
end
