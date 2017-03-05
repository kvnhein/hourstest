class AddLegitHourToEvents < ActiveRecord::Migration
  def change
    add_column :events, :legit_hour, :boolean
  end
end
