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

  def require_admin_construction
  if user_signed_in?
	  redirect_to '/' unless current_user.admin?
  else
    redirect_to '/'
  end
 end

  def admin_redirect
    if user_signed_in?
      if current_user.admin?
	        redirect_to '/landing'
      else
          redirect_to '/'
      end
    end
  end

end

# require 'sinatra'
# require 'pusher'

# pusher = Pusher::Client.new({
# 	app_id: ENV["252122"],
# 	key: ENV["e29028c930b5a4a8f36e"],
# 	secret: ENV["6eb92e761b586328a484"]
# })

# get '/' do
# 	erb :index
# end

# post '/notification' do
# 	message = params[:message]
# 	pusher.trigger('notifications', 'new_notification', {
# 		message: message
# 	})
# end
