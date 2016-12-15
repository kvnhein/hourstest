json.array!(@reservations) do |reservation|
  json.extract! reservation, :id, :user_id, :daily_specials_id, :credit
  json.url reservation_url(reservation, format: :json)
end
