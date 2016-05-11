@b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour #this is what decides whether a special will be shown of clear
@c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)

if Time.now.in_time_zone("Eastern Time (US & Canada)").hour < 2 && Time.now.in_time_zone("Eastern Time (US & Canada)").wday != 0
   x = Time.now.in_time_zone("Eastern Time (US & Canada)").wday.to_i - 1
elsif Time.now.in_time_zone("Eastern Time (US & Canada)").hour < 2 && Time.now.in_time_zone("Eastern Time (US & Canada)").wday == 0
  x = 6
else
  x = Time.now.in_time_zone("Eastern Time (US & Canada)").wday
end

if x == 0
  @day_tag= "Sunday"
elsif x == 1
  @day_tag= "Monday"
elsif x == 2
  @day_tag= "Tuesday"
elsif x == 3
  @day_tag= "Wednesday"
elsif x == 4
  @day_tag= "Thursday"
elsif x == 5
  @day_tag= "Friday"
elsif x == 6
  @day_tag= "Saturday"
end

@v = @venues.where( neighborhood_id: 2)
if Time.now.Saturday? || Time.now.Sunday?
@events = Event.where(venue_id: @v.pluck(:id), day: @day_tag || "Everyday")
else
   @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag || "Weekdays")
end