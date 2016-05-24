class AddDetailToEvents < ActiveRecord::Migration
  def change
    add_column :events, :detail, :text
  end
end
