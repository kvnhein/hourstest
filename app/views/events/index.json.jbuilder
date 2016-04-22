json.array!(@events) do |event|
  json.extract! event, :id, :special, :day, :venue_id, :start, :end
  json.url event_url(event, format: :json)
end
