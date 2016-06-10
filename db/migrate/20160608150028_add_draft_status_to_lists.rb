class AddDraftStatusToLists < ActiveRecord::Migration
  def change
    add_column :lists, :draft_Status, :string
  end
end
