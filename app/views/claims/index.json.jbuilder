json.array!(@claims) do |claim|
  json.extract! claim, :id, :user_id, :event_id
  json.url claim_url(claim, format: :json)
end
