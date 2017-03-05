class AddDeleteDateToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :delete_date, :date
  end
end
