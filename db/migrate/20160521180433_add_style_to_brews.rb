class AddStyleToBrews < ActiveRecord::Migration
  def change
    add_column :brews, :style, :string
  end
end
