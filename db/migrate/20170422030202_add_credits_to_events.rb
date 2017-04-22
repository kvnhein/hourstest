class AddCreditsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :credits, :integer
  end
end
