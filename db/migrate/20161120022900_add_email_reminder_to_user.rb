class AddEmailReminderToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_reminder, :boolean
  end
end
