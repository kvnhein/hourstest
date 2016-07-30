class AddAttachmentImageToDailySpecials < ActiveRecord::Migration
  def self.up
    change_table :daily_specials do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :daily_specials, :image
  end
end
