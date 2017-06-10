class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  belongs_to :venue
  
  validates_presence_of :content, :conversation_id, :user_id

  def message_time
  	created_at.strftime("%B #{Time.now.day.ordinalize}, %Y") 
  end

end
