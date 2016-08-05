class EventsController < ApplicationController
  after_filter "save_my_previous_url", only: [:new]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :require_owner_event, only: [:edit, :update, :destroy]
  autocomplete :event, :special, :full => true
  # GET /events
  # GET /events.json
  def about_us

  end

  def urbanist
    @autocomplete_path = urbanist_autocomplete_event_special_path
    @neighborhood_path = urbanist_path
    @today = Time.now
    @week_ago = 7.day.ago
    @month_ago = 1.month.ago
    @shadyside_venues = Venue.where(urbanist: true, neighborhood_id: 2)
    @south_side_venues = Venue.where(urbanist: true, neighborhood_id: 1)
    @oakland_venues = Venue.where(urbanist: true, neighborhood_id: 3)
    @lawrenceville_venues = Venue.where(urbanist: true, neighborhood_id: 6)
    @market_square_venues = Venue.where(urbanist: true, neighborhood_id: 5)
    @verified_this_week = Venue.between_times(@week_ago, @today)
    @verified_after_week = Venue.between_times(@month_ago,@week_ago)
    @verified_month_ago = Venue.before(@month_ago)
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    t= Time.now.in_time_zone("Eastern Time (US & Canada)")

    if t.wday == 0 && @b < 2
      x = 6
    elsif @b < 2
      x = t.wday - 1
    else
      x = t.wday
    end

       if  x == 0
       @day_tag = "Sunday"
       elsif x == 1
       @day_tag = "Monday"
       elsif x == 2
       @day_tag = "Tuesday"
       elsif x == 3
       @day_tag = "Wednesday"
       elsif x == 4
       @day_tag = "Thursday"
       elsif x == 5
       @day_tag = "Friday"
       else
       @day_tag = "Saturday"
       end


   @v = @venues.where( urbanist: true)
   @daily_specials = DailySpecial.where(venue_id: @v.pluck(:id), day: @day_tag)
   @events = Event.where(day: @day_tag)
   if params[:search]
      @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag).special_like("%#{params[:search]}%").order('special')
    else
    end

    @todays_feature = DailySpecial.where(venue_id: @v.pluck(:id)).today
  end

  def save_my_previous_url
    # session[:previous_url] is a Rails built-in variable to save last url.
    session[:my_previous_url] = URI(request.referer || '').path
  end

  def index
    @events = Event.all
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    @l = Time.now.in_time_zone("Eastern Time (US & Canada)").min
  end

  def shadyside
    @autocomplete_path = shadyside_autocomplete_event_special_path
    @neighborhood_path = shadyside_path
    @today = Time.now
    @week_ago = 7.day.ago
    @month_ago = 1.month.ago
    @verified_this_week = Venue.between_times(@week_ago, @today)
    @verified_after_week = Venue.between_times(@month_ago,@week_ago)
    @verified_month_ago = Venue.before(@month_ago)
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    t= Time.now.in_time_zone("Eastern Time (US & Canada)")

    if t.wday == 0 && @b < 2
      x = 6
    elsif @b < 2
      x = t.wday - 1
    else
      x = t.wday
    end

       if  x == 0
       @day_tag = "Sunday"
       elsif x == 1
       @day_tag = "Monday"
       elsif x == 2
       @day_tag = "Tuesday"
       elsif x == 3
       @day_tag = "Wednesday"
       elsif x == 4
       @day_tag = "Thursday"
       elsif x == 5
       @day_tag = "Friday"
       else
       @day_tag = "Saturday"
       end

   @neighborhood_tag = 2
   @v = @venues.where( neighborhood_id: 2)
   @daily_specials = DailySpecial.where(venue_id: @v.pluck(:id), day: @day_tag)
   @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag)
   if params[:search]
      @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag).special_like("%#{params[:search]}%").order('special')
    else
    end

    @todays_feature = DailySpecial.today
  end

  def south_side
    @autocomplete_path = south_side_autocomplete_event_special_path
    @neighborhood_path = south_side_path
    @today = Time.now
    @week_ago = 7.day.ago
    @month_ago = 1.month.ago
    @verified_this_week = Venue.between_times(@week_ago, @today)
    @verified_after_week = Venue.between_times(@month_ago,@week_ago)
    @verified_month_ago = Venue.before(@month_ago)
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    t= Time.now.in_time_zone("Eastern Time (US & Canada)")

    if t.wday == 0 && @b < 2
      x = 6
    elsif @b < 2
      x = t.wday - 1
    else
      x = t.wday
    end

       if  x == 0
       @day_tag = "Sunday"
       elsif x == 1
       @day_tag = "Monday"
       elsif x == 2
       @day_tag = "Tuesday"
       elsif x == 3
       @day_tag = "Wednesday"
       elsif x == 4
       @day_tag = "Thursday"
       elsif x == 5
       @day_tag = "Friday"
       else
       @day_tag = "Saturday"
       end

   @neighborhood_tag = 1
   @v = @venues.where( neighborhood_id: 1)
   @daily_specials = DailySpecial.where(venue_id: @v.pluck(:id))
   @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag)
   if params[:search]
      @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag).special_like("%#{params[:search]}%").order('special')
    else
    end

    @todays_feature = DailySpecial.today
  end

  def oakland
    @autocomplete_path = oakland_autocomplete_event_special_path
    @neighborhood_path = oakland_path
    @today = Time.now
    @week_ago = 7.day.ago
    @month_ago = 1.month.ago
    @verified_this_week = Venue.between_times(@week_ago, @today)
    @verified_after_week = Venue.between_times(@month_ago,@week_ago)
    @verified_month_ago = Venue.before(@month_ago)
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    t= Time.now.in_time_zone("Eastern Time (US & Canada)")

    if t.wday == 0 && @b < 2
      x = 6
    elsif @b < 2
      x = t.wday - 1
    else
      x = t.wday
    end

       if  x == 0
       @day_tag = "Sunday"
       elsif x == 1
       @day_tag = "Monday"
       elsif x == 2
       @day_tag = "Tuesday"
       elsif x == 3
       @day_tag = "Wednesday"
       elsif x == 4
       @day_tag = "Thursday"
       elsif x == 5
       @day_tag = "Friday"
       else
       @day_tag = "Saturday"
       end

   @neighborhood_tag = 3
   @v = @venues.where( neighborhood_id: 3)
   @daily_specials = DailySpecial.where(venue_id: @v.pluck(:id))
   @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag)
   if params[:search]
      @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag).special_like("%#{params[:search]}%").order('special')
    else
    end

    @todays_feature = DailySpecial.all
  end

  def market_square
    @autocomplete_path = market_square_autocomplete_event_special_path
    @neighborhood_path = market_square_path
    @today = Time.now
    @week_ago = 7.day.ago
    @month_ago = 1.month.ago
    @verified_this_week = Venue.between_times(@week_ago, @today)
    @verified_after_week = Venue.between_times(@month_ago,@week_ago)
    @verified_month_ago = Venue.before(@month_ago)
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    t= Time.now.in_time_zone("Eastern Time (US & Canada)")

    if t.wday == 0 && @b < 2
      x = 6
    elsif @b < 2
      x = t.wday - 1
    else
      x = t.wday
    end

       if  x == 0
       @day_tag = "Sunday"
       elsif x == 1
       @day_tag = "Monday"
       elsif x == 2
       @day_tag = "Tuesday"
       elsif x == 3
       @day_tag = "Wednesday"
       elsif x == 4
       @day_tag = "Thursday"
       elsif x == 5
       @day_tag = "Friday"
       else
       @day_tag = "Saturday"
       end

   @neighborhood_tag = 5
   hood_id = Neighborhood.where(id: 5).first.id
   @v = @venues.where( neighborhood_id: hood_id)
   @daily_specials = DailySpecial.where(venue_id: @v.pluck(:id))
   @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag)
   if params[:search]
      @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag).special_like("%#{params[:search]}%").order('special')
    else
    end

    @todays_feature = DailySpecial.today
  end

  def lawrenceville
    @autocomplete_path = lawrenceville_autocomplete_event_special_path
    @neighborhood_path = lawrenceville_path
    @today = Time.now
    @week_ago = 7.day.ago
    @month_ago = 1.month.ago
    @verified_this_week = Venue.between_times(@week_ago, @today)
    @verified_after_week = Venue.between_times(@month_ago,@week_ago)
    @verified_month_ago = Venue.before(@month_ago)
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    t= Time.now.in_time_zone("Eastern Time (US & Canada)")

    if t.wday == 0 && @b < 2
      x = 6
    elsif @b < 2
      x = t.wday - 1
    else
      x = t.wday
    end

       if  x == 0
       @day_tag = "Sunday"
       elsif x == 1
       @day_tag = "Monday"
       elsif x == 2
       @day_tag = "Tuesday"
       elsif x == 3
       @day_tag = "Wednesday"
       elsif x == 4
       @day_tag = "Thursday"
       elsif x == 5
       @day_tag = "Friday"
       else
       @day_tag = "Saturday"
       end

   @neighborhood_tag = 7
   hood_id = Neighborhood.where(id: 7).first.id
   @v = @venues.where( neighborhood_id: hood_id)
   @daily_specials = DailySpecial.where(venue_id: @v.pluck(:id))
   @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag)
   if params[:search]
      @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag).special_like("%#{params[:search]}%").order('special')
    else
    end

    @todays_feature = DailySpecial.today
  end

  def bloomfield
    @autocomplete_path = bloomfield_autocomplete_event_special_path
    @neighborhood_path = bloomfield_path
    @today = Time.now
    @week_ago = 7.day.ago
    @month_ago = 1.month.ago
    @verified_this_week = Venue.between_times(@week_ago, @today)
    @verified_after_week = Venue.between_times(@month_ago,@week_ago)
    @verified_month_ago = Venue.before(@month_ago)
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    t= Time.now.in_time_zone("Eastern Time (US & Canada)")

    if t.wday == 0 && @b < 2
      x = 6
    elsif @b < 2
      x = t.wday - 1
    else
      x = t.wday
    end

       if  x == 0
       @day_tag = "Sunday"
       elsif x == 1
       @day_tag = "Monday"
       elsif x == 2
       @day_tag = "Tuesday"
       elsif x == 3
       @day_tag = "Wednesday"
       elsif x == 4
       @day_tag = "Thursday"
       elsif x == 5
       @day_tag = "Friday"
       else
       @day_tag = "Saturday"
       end

   @neighborhood_tag = 6
   hood_id = Neighborhood.where(id: 6).first.id
   @v = @venues.where( neighborhood_id: hood_id)
   @daily_specials = DailySpecial.where(venue_id: @v.pluck(:id))
   @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag)
   if params[:search]
      @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag).special_like("%#{params[:search]}%").order('special')
    else
    end

    @todays_feature = DailySpecial.today
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @back_url = session[:my_previous_url]
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        Venue.where(id: @event.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to Venue.where(id: @event.venue_id).first, notice: 'Hour was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        Venue.where(id: @event.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to Venue.where(id: @event.venue_id).first, notice: 'Hour was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      Venue.where(id: @event.venue_id).first.update_attribute(:venue_verify, Time.now)
      format.html { redirect_to Venue.where(id: @event.venue_id).first, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:special,:detail, :day, :venue_id, :start, :end)
    end
end
