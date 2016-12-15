class AddVarifiedUserToEvents < ActiveRecord::Migration
  def change
    add_column :events, :varified_user, :integer
  end
end
