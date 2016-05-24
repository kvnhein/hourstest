class Brew < ActiveRecord::Base
  
   def full_brew_name
    "#{name} (#{brewery})"
  end 
end
