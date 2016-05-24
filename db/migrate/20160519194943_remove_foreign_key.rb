class RemoveForeignKey < ActiveRecord::Migration
  def change
    remove_foreign_key :beers, :venues
  end
end
