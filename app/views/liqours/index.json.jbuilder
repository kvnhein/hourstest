json.array!(@liqours) do |liqour|
  json.extract! liqour, :id, :name, :description, :distillery, :liqour_status, :liqour_type
  json.url liqour_url(liqour, format: :json)
end
