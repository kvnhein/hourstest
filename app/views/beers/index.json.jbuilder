json.array!(@beers) do |beer|
  json.extract! beer, :id, :name, :brewery, :abv, :type, :price, :serving, :details, :venue_id
  json.url beer_url(beer, format: :json)
end
