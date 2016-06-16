json.array!(@drinks) do |drink|
  json.extract! drink, :id
  json.url drink_url(drink, format: :json)
end
