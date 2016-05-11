class Event < ActiveRecord::Base
  
  belongs_to :venue
  
  def check_if_after_midnight?

  end


end

