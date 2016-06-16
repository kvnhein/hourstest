json.array!(@daily_specials) do |daily_special|
  json.extract! daily_special, :id, :text, :description, :price, :venue_id, :dish_type
  json.url daily_special_url(daily_special, format: :json)
end
