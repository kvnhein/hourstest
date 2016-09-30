# require 'pusher'

# pusher = Pusher::Client.new app_id: '252122', key: 'e29028c930b5a4a8f36e', secret: '6eb92e761b586328a484'

# # trigger on my_channel' an event called 'my_event' with this payload:

# require 'sinatra' # requires `gem install sinatra`

# post '/notification' do
#     message = params[:message]

#     pusher.trigger('notifications', 'new_notification', {
#         message: message
#     })
# end

# # don't forget to render your index.html page

# get '/' do
#     erb :landing
# end