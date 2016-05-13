class RenameBeerColumnType < ActiveRecord::Migration
  def change
    rename_column :beers, :type, :genre
  end
end
