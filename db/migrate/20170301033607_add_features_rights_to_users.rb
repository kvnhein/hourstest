class AddFeaturesRightsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :feature_rights, :boolean
  end
end
