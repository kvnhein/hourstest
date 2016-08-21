class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :get_neighborhoods
  before_filter :get_venues
  before_action :configure_permitted_parameters, if: :devise_controller? 
  

protected

def configure_permitted_parameters
  devise_parameter_sanitizer.for(:sign_up) << :fullname
  devise_parameter_sanitizer.for(:account_update) << :fullname
end
  
def get_neighborhoods
	@neighborhoods ||= Neighborhood.all
 
end
def get_venues
	@venues ||= Venue.all
 
end


 def require_admin
  if user_signed_in?
	  redirect_to '/' unless current_user.admin?
  else
    redirect_to '/'
  end
 end

  def require_owner
    if user_signed_in?
       redirect_to '/' unless current_user.id == @venue.owner || current_user.admin?
    else
      redirect_to '/'
    end
  end

  def require_owner_event
    if user_signed_in?
       redirect_to '/' unless current_user.id == Venue.where(id: @event.venue_id).first.owner || current_user.admin?
    else
      redirect_to '/'
    end
  end

  def require_user
     redirect_to '/' unless current_user
   end



end
