json.array!(@venues) do |venue|
  json.extract! venue, :id, :name, :address, :longitude, :latitude, :neighborhood_id, :owner
  json.url venue_url(venue, format: :json)
end
