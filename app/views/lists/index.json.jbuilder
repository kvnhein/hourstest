json.array!(@lists) do |list|
  json.extract! list, :id, :venue_id, :brew_id, :serving_style, :serving_size, :price, :status
  json.url list_url(list, format: :json)
end
