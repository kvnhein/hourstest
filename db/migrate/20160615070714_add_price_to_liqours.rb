class AddPriceToLiqours < ActiveRecord::Migration
  def change
    add_column :liqours, :price, :string
  end
end
