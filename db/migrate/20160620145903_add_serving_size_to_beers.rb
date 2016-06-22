class AddServingSizeToBeers < ActiveRecord::Migration
  def change
    add_column :beers, :serving_size, :string
  end
end
