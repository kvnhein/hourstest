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