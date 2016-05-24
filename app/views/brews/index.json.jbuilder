json.array!(@brews) do |brew|
  json.extract! brew, :id, :name, :brewery, :detail, :abv
  json.url brew_url(brew, format: :json)
end
