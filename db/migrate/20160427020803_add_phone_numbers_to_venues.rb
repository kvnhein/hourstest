class AddPhoneNumbersToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :phone_number, :string
  end
end
