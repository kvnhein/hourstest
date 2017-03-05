module ApplicationHelper
  def avatar_url(user)
		gravatar_id = Digest::MD5::hexdigest(user.email).downcase 
		if user.image
			user.image
		else
			"profile_icon.jpg"
		end
	end
	
  def phone_number_link(text)
    sets_of_numbers = text.scan(/[0-9]+/)
    number = "+1-#{sets_of_numbers.join('-')}"
    link_to text, "tel:#{number}"
  end

  def paginate(collection, params= {})
   will_paginate @collection, {link_options: {'data-remote': true}, params: {action: 'other_action'}}
  end

end
