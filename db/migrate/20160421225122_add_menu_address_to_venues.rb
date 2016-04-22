class AddMenuAddressToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :menu_address, :string
  end
end
