class EventsController < ApplicationController
 

   after_filter "save_my_previous_url", only: [:new]
 # before_action :admin_redirect, only: [:under_construction]
   #before_action :require_admin_construction, except: [:under_construction]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :event_upvote, :event_downvote, :event_verified]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
 # before_action :require_owner_event, only: [:edit, :update, :destroy]
  before_action :verified_venues, only: [:landing,:urbanist, :downtown,:shadyside, :south_side, :lawrenceville, :oakland, :north_side, :bloomfield, :east_liberty, :strip_district, :squirrel_hill, :mt_washington]
  before_action :event_time, only: [:daily_mailer,:shadyside, :south_side, :lawrenceville, :oakland, :north_side, :bloomfield, :east_liberty, :strip_district, :downtown, :squirrel_hill, :user_index, :mt_washington]
  autocomplete :event, :special, :full => true
  
  # GET /events
  # GET /events.json
  def privacy
  end 
    
  def under_construction
  end
  
  def event_tags
     if params[:tag] == "Food"
      @events = Event.where(food: true)
    elsif params[:tag] == "Drinks"
     @events = Event.where(drinks: true)
    elsif params[:tag] == "Late Nite"
     @events = Event.where(late_nite: true)
    elsif params[:tag] == "Entertainment"
     @events = Event.where(entertainment: true)
    end
  end 
  
  def user_index
      @users = User.all
      @urbanist_venues = Venue.where(urbanist: true)
      @events = Event.where(day: @day_specials)
  end
  
  def event_verified
    if @event.event_verify || @event.varified_user
        @event.update_attribute(:event_verify, Time.now)
        @event.update_attribute(:varified_user, current_user.id)
        Venue.find(@event.venue_id).update_attribute(:venue_verify, Time.now)
        current_user.increment!(:experience, by = 10)
        current_user.increment!(:num_verified, by = 1)
    else
        @event.event_verify = Time.now
        @event.varified_user = current_user.id
        current_user.increment!(:experience, by = 10)
        current_user.increment!(:num_verified, by = 1)
        @event.save
    end 
    Venue.find(@event.venue_id).venue_avg_verify
  end

  def daily_mailer
    @new_events = Event.after(Date.today - 7).to_a
    @updated_events = Event.after(Date.today - 7, field: :updated_at).to_a
    @users = User.all
    @users.each do |user|
        #EventMailer.welcome_email(user).deliver
      #users_likes = user.get_up_voted Event.where(day: @day_specials)
      #if users_likes != 0
        #EventMailer.event_reminder_email(user, users_likes).deliver
        #EventMailer.welcome_email(user, users_likes).deliver
      #end
    end
  end


  def verified_venues
    @claim = Claim.new
    @today = Time.now
    @week_ago = 7.day.ago
    @month_ago = 1.month.ago
    
    #@verified_this_week = Venue.between_times(@week_ago, @today)
    #@verified_after_week = Venue.between_times(@month_ago,@week_ago)
    #@verified_month_ago = Venue.before(@month_ago)
    #@owned_venues = Venue.where("owner > ?", 1)
    #@verified_this_week = Venue.where("avg_verify < ?", 7)
    #@verified_after_week = Venue.where(avg_verify: [7...30] )
    #@verified_month_ago = Venue.where("avg_verify > ?", 29)
    #@verified_this_week = Venue.all
    
    
    claim_index = Claim.all
    claim_index.each do |claim|
        if claim.status == 1 && (claim.created_at + 7.days).to_date == Date.current
           # claim.event.status = 1
           # claim.event.save
           # claim.destroy
        elsif claim.status == 0 && (claim.created_at + 7.days).to_date == Date.current
            #claim.destroy
        end
    end
    if (user_signed_in?)
        @signed_in = true
        @user_likes = current_user.find_up_voted_items.to_a
    else
        @signed_in = false
    end
    @current_voter = current_user
    
  end

  def event_time
    #@event_all = Event.all
    #@venue_all = Venue.all
    #@daily_special_all = DailySpecial.all
    #@claim_all = Claim.all
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


      if  x == 0
       @day_specials = "Sunday"
       elsif x == 1
       @day_specials = "Monday"
       elsif x == 2
       @day_specials = "Tuesday"
       elsif x == 3
       @day_specials = "Wednesday"
       elsif x == 4
       @day_specials = "Thursday"
       elsif x == 5
       @day_specials = "Friday"
       else
       @day_specials = "Saturday"
      end
  end

  def event_upvote
  @event.liked_by current_user
    current_user.increment!(:experience, by = 5)
    current_user.count_events_saved
    if @event.super_vote?
        @event.legit_hour = true
        @event.save!
    end
  end

  def event_downvote
  @event.unliked_by current_user
    current_user.decrement!(:experience, by = 5)
    current_user.decrement!(:num_events_saved, by = 1)
  end

  def landing
    
    
    #this is for OG
    @topic = "Hours"
    @topic_description = "Hours provides Happy Hours/Specials and Featured dishes throughout Pittsburgh"
    @page_url = ""
    events = Event.all 
    @new_events = events.all_cached.after(Date.today - 7)
    @todays_events = events.all_cached.after(Date.today - 7).to_a
    
    @todays_venues = @venues.to_a
    @date = Date.today 
    @updated_events = Event.new_events_cached
    @events_with_claims = []
    @venues = Venue.all_cached.to_a
    @claims = Claim.all.to_a
    @claims_all = @claims
    @neighborhoods = Neighborhood.all.to_a
    claim_event_id = @claims.map{|claim| claim.event_id } 
    @users = User.all.to_a
    @user_array = @users.sort!{|x,y| y.experience <=> x.experience }
    
    @top_users = []
    @users.each do |user|
        if user.fullname
            @top_users.push(user)
        end 
    end 
    

    
  end

  def urbanist
      
    @users = User.all
    @urbanist_venues = @venues.all
    venues = Venue.all.to_a
    @events = Event.where(day: @day_specials).to_a
      @claims_all = Claim.all.to_a
    #this is for OG
    @topic = "Happy Hours at Urbanist Approved Venues in Pittsburgh"
    @topic_description = "URBANIST guide aims to produce the best printed city guides in the nation"

    @autocomplete_path = urbanist_autocomplete_event_special_path
    @neighborhood_path = urbanist_path
    @today = Time.now
    @week_ago = 7.day.ago
    @month_ago = 1.month.ago

    @shadyside_venues = @venues.where(neighborhood_id: 2)
    @south_side_venues = @venues.where(neighborhood_id: 1)
    @oakland_venues = @venues.where(neighborhood_id: 3)
    @lawrenceville_bloomfield_venues = @venues.where(neighborhood_id: [7,6])
    @market_square_venues = @venues.where( neighborhood_id: 5)
    @strip_district_venues = @venues.where(neighborhood_id: 11)

    @urbanist_venues = Venue.all
    @daily_specials =  DailySpecial.today

    @verified_this_weeku = @venues.between_times(@week_ago, @today).where(urbanist: true)
    @verified_after_weeku = @venues.between_times(@month_ago,@week_ago).where(urbanist: true)
    @verified_month_agou = @venues.before(@month_ago).where(urbanist: true)



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



    @tag_events = Event.all
   @v = @venues.where( urbanist: true)

   @events = Event.where(day: @day_tag).to_a
   if params[:search]
      @events = Event.where(venue_id: @v.pluck(:id), day: @day_tag).special_like("%#{params[:search]}%").order('special')
    elsif params[:urb_tag]
      @events = Event.tagged_with(params[:urb_tag]).where(day: @day_tag)
      @tag_topic = "##{params[:urb_tag]}"
    end
  end

  def save_my_previous_url
    # session[:previous_url] is a Rails built-in variable to save last url.
    session[:my_previous_url] = URI(request.referer || '').path
  end

  def index
    @events = Event.all
    @v = @venues.all
    @daily_specials = DailySpecial.where(venue_id: @v.pluck(:id), day: @day_tag)
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    @l = Time.now.in_time_zone("Eastern Time (US & Canada)").min
  end

 def shadyside
   @users = User.all.to_a
   neighborhood_id = 2
   @neighborhoods_all = Neighborhood.all.to_a
   @events_all = Event.order(:cached_votes_total => :asc).all_cached.to_a
   @venues_all = Venue.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 7.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
    if params[:search]
      @events = Event.where(venue_id: venue_id, day: @day_specials).special_like("%#{params[:search]}%").order('special').to_a 
      @tag_topic = "##{params[:search]}"
    elsif params[:shady_tag]
      @events = Event.tagged_with(params[:shady_tag]).where(venue_id: venue_id, day: @day_specials)
      @tag_topic = "##{params[:shady_tag]}"
    end
    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}
    @page_url = "shadyside"
   
   @autocomplete_path = shadyside_autocomplete_event_special_path
   @neighborhood_path = shadyside_path
   @neighborhood_tag = 2
    #this is for OG
    @topic = "Hours in Shadyside}"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"
    
    

  end


  def south_side
   @users = User.all.to_a
   neighborhood_id = 1
   @neighborhoods_all = Neighborhood.all.to_a
   @venues_all = Venue.all_cached.to_a
   @events_all = Event.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 7.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
    
    
    if params[:search]
      @events = Event.where(venue_id: venue_id, day: @day_specials).special_like("%#{params[:search]}%").order('special')
      @tag_topic = "##{params[:search]}"    
    elsif params[:south_tag]
      @events = Event.tagged_with(params[:south_tag]).where(venue_id: venue_id, day: @day_specials)
      @tag_topic = "##{params[:south_tag]}"
    end
    
    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}

   
    @neighborhood_tag = 1
    @autocomplete_path = south_side_autocomplete_event_special_path
    @neighborhood_path = south_side_path
     #this is for OG
    @page_url = "southside"
    @topic = "Hours in South Side"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"

  end

  def oakland
   @users = User.all.to_a
   neighborhood_id = 3
   @neighborhoods_all = Neighborhood.all.to_a
   @venues_all = Venue.all_cached.to_a
   @events_all = Event.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 7.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
   
   
    if params[:search]
      @events = Event.where(venue_id: venue_id, day: @day_specials).special_like("%#{params[:search]}%").order('special')
      @tag_topic = "##{params[:search]}"
    elsif params[:oakland_tag]
      @events = Event.tagged_with(params[:oakland_tag]).where(venue_id: venue_id, day: @day_specials)
      @tag_topic = "##{params[:oakland_tag]}"
    end

    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}
    
    @autocomplete_path = oakland_autocomplete_event_special_path
    @neighborhood_path = oakland_path

     #this is for OG
    @neighborhood_tag = 3
    @page_url = "oakland"
    @topic = "Hours in Oakland"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"

  end

  def downtown
   
   neighborhood_id = 5
   @users = User.all.to_a
   
   @venues_all = Venue.includes(:events).all_cached.to_a
   @events_all = Event.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   @claim_voters = []
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 8.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
   
    if params[:search]
      @events = Event.where(venue_id: venue_id, day: @day_specials).special_like("%#{params[:search]}%").order('special')
      @tag_topic = "##{params[:search]}"
     elsif params[:down_tag]
      @events = Event.tagged_with(params[:down_tag]).where(venue_id: venue_id, day: @day_specials)
     @tag_topic = "##{params[:down_tag]}"
    end
    
    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}
    
    @autocomplete_path = downtown_autocomplete_event_special_path
    @neighborhood_path = downtown_path
    @neighborhood_tag = 5
     #this is for OG
    
    @page_url = "downtown"
    @topic = "Hours in Downtown"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"

  end


  def lawrenceville
   @users = User.all.to_a
   neighborhood_id = 7
   @neighborhoods_all = Neighborhood.all.to_a
   @venues_all = Venue.all_cached.to_a
   @events_all = Event.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 7.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
   
   if params[:search]
     @events = Event.where(venue_id: venue_id, day: @day_specials).special_like("%#{params[:search]}%").order('special')
     @tag_topic = "##{params[:search]}"
   elsif params[:law_tag]
      @events = Event.tagged_with(params[:law_tag]).where(venue_id: venue_id, day: @day_specials)
     @tag_topic = "##{params[:law_tag]}" 
   end
   
    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}

   @autocomplete_path = lawrenceville_autocomplete_event_special_path
   @neighborhood_path = lawrenceville_path
   @neighborhood_tag = 7
     #this is for OG
    @page_url = "lawrencville"
    @topic = "Hours in Lawrenceville"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"
  end


  def bloomfield
   neighborhood_id = 6
   @users = User.all.to_a
   @neighborhoods_all = Neighborhood.all.to_a
   @venues_all = Venue.all_cached.to_a
   @events_all = Event.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 7.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
   
    if params[:search]
      @events = Event.where(venue_id: venue_id, day: @day_specials).special_like("%#{params[:search]}%").order('special')
      @tag_topic = "##{params[:search]}"
    elsif params[:bloom_tag]
      @events = Event.tagged_with(params[:bloom_tag]).where(venue_id: venue_id, day: @day_specials)
     @tag_topic = "##{params[:bloom_tag]}"
    end

    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}

    
    @autocomplete_path = bloomfield_autocomplete_event_special_path
    @neighborhood_path = bloomfield_path
    @neighborhood_tag = 6
     #this is for OG
    @page_url = "bloomfield"
    @topic = "Hours in Bloomfield"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"
  end


  def east_liberty
   neighborhood_id = 9
   @users = User.all.to_a
   @neighborhoods_all = Neighborhood.all.to_a
   @venues_all = Venue.all_cached.to_a
   @events_all = Event.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 7.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
   
    if params[:search]
      @events = Event.where(venue_id: venue_id , day: @day_specials).special_like("%#{params[:search]}%").order('special')
      @tag_topic = "##{params[:search]}"
    elsif params[:east_tag]
      @events = Event.tagged_with(params[:east_tag]).where(venue_id: venue_id , day: @day_specials)
      @tag_topic = "##{params[:east_tag]}"
    end

    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}

   
   @autocomplete_path = east_liberty_autocomplete_event_special_path
   @neighborhood_path = east_liberty_path
   @neighborhood_tag = 9
     #this is for OG
    @page_url = "east_liberty"
    @topic = "Hours in East Liberty"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"
  end


  def strip_district
    neighborhood_id = 11
    @users = User.all.to_a
   @neighborhoods_all = Neighborhood.all.to_a
   @venues_all = Venue.all_cached.to_a
   @events_all = Event.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 7.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
   
   if params[:search]
     @events = Event.where(venue_id: venue_id, day: @day_specials).special_like("%#{params[:search]}%").order('special')
     @tag_topic = "##{params[:search]}"
   elsif params[:strip_tag]
      @events = Event.tagged_with(params[:strip_tag]).where(venue_id: venue_id, day: @day_specials)
     @tag_topic = "##{params[:strip_tag]}"
   end
    
    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}
    
    
   @autocomplete_path = strip_district_autocomplete_event_special_path
   @neighborhood_path = strip_district_path
   @neighborhood_tag = 11
     #this is for OG
    @page_url = "strip_district"
    @topic = "Hours in #{Neighborhood.find(@neighborhood_tag).name}"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"
  end

  def squirrel_hill
    neighborhood_id = 10
    @users = User.all.to_a
   @neighborhoods_all = Neighborhood.all.to_a
   @venues_all = Venue.all_cached.to_a
   @events_all = Event.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 7.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
   
   if params[:search]
      @events = Event.where(venue_id: venue_id, day: @day_specials).special_like("%#{params[:search]}%").order('special')
      @tag_topic = "##{params[:search]}"
   elsif params[:sq_tag]
      @events = Event.tagged_with(params[:sq_tag]).where(venue_id: venue_id, day: @day_specials)
      @tag_topic = "##{params[:sq_tag]}"
   end

    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}
    
   @autocomplete_path = bloomfield_autocomplete_event_special_path
   @neighborhood_path = bloomfield_path
   @neighborhood_tag = 10

     #this is for OG
    @page_url = "squirrel_hill"
    @topic = "Hours in Squirrel Hill"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"
  end

  def north_side
    neighborhood_id = 12
    @users = User.all.to_a
   @neighborhoods_all = Neighborhood.all.to_a
   @venues_all = Venue.all_cached.to_a
   @events_all = Event.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 7.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
   
   
  if params[:search]
      @events = Event.where(venue_id: venue_id, day: @day_specials).special_like("%#{params[:search]}%").order('special')
      @tag_topic = "##{params[:search]}"
   elsif params[:north_tag]
      @events = Event.tagged_with(params[:north_tag]).where(venue_id: venue_id, day: @day_specials)
      @tag_topic = "##{params[:north_tag]}"
   end

    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}
   
   @autocomplete_path = north_side_autocomplete_event_special_path
   @neighborhood_path = north_side_path
   @neighborhood_tag = 12

     #this is for OG
    @page_url = "north_side"
    @topic = "Hours in North Side"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"
  end

  def mt_washington
    neighborhood_id = 13
    @users = User.all.to_a
   @neighborhoods_all = Neighborhood.all.to_a
   @venues_all = Venue.all_cached.to_a
   @events_all = Event.all_cached.to_a
   @claims_all = Claim.all.to_a
   @daily_specials_all = DailySpecial.all.to_a
   
   @venues = @venues_all.select {|venue| venue.neighborhood_id == neighborhood_id }
   venue_id = @venues.map { |venue| venue.id }
   @daily_specials = @daily_specials_all.select {|special| special.created_at > (Date.current - 7.days)}.select{|special|  venue_id.include?(special.venue_id)}
   @events = @events_all.select{|event|  venue_id.include?(event.venue_id)}.select {|event| @day_specials.include?(event.day)}.sort! {|x,y| (y.cached_votes_total + y.credits) <=> (x.cached_votes_total + x.credits)}
   @tag_events = Event.where(venue_id: venue_id, day: @day_specials)
   @tag_topic = ""
   
   if params[:search]
      @events = Event.where(venue_id: venue_id, day: @day_specials).special_like("%#{params[:search]}%").order('special')
      @tag_topic = "##{params[:search]}"
   elsif params[:mt_tag]
      @events = Event.tagged_with(params[:mt_tag]).where(venue_id: venue_id, day: @day_specials)
      @tag_topic = "##{params[:mt_tag]}"
   end

    @todays_feature =  @daily_specials
    @new_events = @events.select {|event| event.created_at > (Date.current - 7.days)}
    @verify_events= @events.select {|event| event.event_verify > (Date.current - 60.days)}
   
   @autocomplete_path = mt_washington_autocomplete_event_special_path
   @neighborhood_path = mt_washington_path
   @neighborhood_tag = 13
    
     #this is for OG
    @page_url = "mt_washington"
    @topic = "Hours in Mt.Washington"
    @topic_description = "Never miss another happy hour in Pittsburgh with HoursPGH"
  end

  # GET /events/1
  # GET /events/1.json
  def show
      
      @reviews = @event.reviews
      @hasReview = @reviews.find_by(user_id: current_user.id) if current_user
  end

  # GET /events/new
  def new
    @event = current_user.events.build
    #@event = Event.new
    @back_url = session[:my_previous_url]
  end

  # GET /events/1/edit
  def edit
    event2 = @event
    if event2.food == false    
        event2.tag_list.remove("Food")
    elsif event2.food == true 
        event2.tag_list.add("Food")
    end
    if event2.drinks == false    
        event2.tag_list.remove("Drinks")
    elsif event2.drinks == true 
        event2.tag_list.add("Drinks")
    end
    if event2.late_nite == false    
        event2.tag_list.remove("Late nite")
    elsif event2.late_nite == true 
        event2.tag_list.add("Late nite")
    end
    if event2.entertainment == false    
        event2.tag_list.remove("Entertainment")
    elsif event2.entertainment == true 
        event2.tag_list.add("Entertainment")
    end
  end

  # POST /events
  # POST /events.json
  def create

    
    @event = current_user.events.build(event_params)
    Venue.find(@event.venue_id).venue_avg_verify
    
    if User.find(@event.user_id).super_user?
        @event.legit_hour = true
        @event.save! 
    end
    
    event2 = @event
    if event2.food == false    
        event2.tag_list.remove("Food")
    elsif event2.food == true 
        event2.tag_list.add("Food")
    end
    if event2.drinks == false    
        event2.tag_list.remove("Drinks")
    elsif event2.drinks == true 
        event2.tag_list.add("Drinks")
    end
    if event2.late_nite == false    
        event2.tag_list.remove("Late nite")
    elsif event2.late_nite == true 
        event2.tag_list.add("Late nite")
    end
    if event2.entertainment == false    
        event2.tag_list.remove("Entertainment")
    elsif event2.entertainment == true 
        event2.tag_list.add("Entertainment")
    end
    
    @event = event2
    #@event = Event.new(event_params)
    if @event.day == "Weekdays"
        @event.day = "Monday"
        @event_tue = current_user.events.build(event_params)
        @event_tue.day = "Tuesday"
        @event_tue.add_tags
        @event_wed = current_user.events.build(event_params)
        @event_wed.day = "Wednesday"
        @event_wed.add_tags
        @event_thu = current_user.events.build(event_params)
        @event_thu.day = "Thursday"
        @event_thu.add_tags
        @event_fri = current_user.events.build(event_params)
        @event_fri.day = "Friday"
        @event_fri.add_tags


        respond_to do |format|
        if @event.save && @event_tue.save && @event_wed.save && @event_thu.save && @event_fri.save
            #EventMailer.sample_email(current_user, @event).deliver

            Venue.find(@event.venue_id).update_attribute(:venue_verify, Time.now)
            format.html { redirect_to Venue.find(@event.venue_id), notice: 'Hour was successfully created.' }
            format.json { head :no_content }
            format.js { render :layout => false }
        else
            format.html { render :new }
            format.json { render json: @event.errors, status: :unprocessable_entity }
        end
    end
    elsif @event.day == "Everyday"
        @event.day = "Monday"
        @event_tue = current_user.events.build(event_params)
        @event_tue.day = "Tuesday"
        @event_wed = current_user.events.build(event_params)
        @event_wed.day = "Wednesday"
        @event_thu = current_user.events.build(event_params)
        @event_thu.day = "Thursday"
        @event_fri = current_user.events.build(event_params)
        @event_fri.day = "Friday"
        @event_sat = current_user.events.build(event_params)
        @event_sat.day = "Saturday"
        @event_sun = current_user.events.build(event_params)
        @event_sun.day = "Sunday"


        respond_to do |format|
            if @event.save && @event_tue.save && @event_wed.save && @event_thu.save && @event_fri.save && @event_sat.save && @event_sun.save
            #EventMailer.sample_email(current_user, @event).deliver

            Venue.find(@event.venue_id).update_attribute(:venue_verify, Time.now)
            format.html { redirect_to Venue.find(@event.venue_id), notice: 'Hour was successfully created.' }
            format.json { head :no_content }
            format.js { render :layout => false } 
            else
            format.html { render :new }
            format.json { render json: @event.errors, status: :unprocessable_entity }
            end
        end
   elsif @event.day == "Weekend"
    @event.day = "Saturday"
    @event_sun = current_user.events.build(event_params)
    @event_sun.day = "Sunday"

    respond_to do |format|
      if @event.save && @event_sun.save
        #EventMailer.sample_email(current_user, @event).deliver

        Venue.find(@event.venue_id).update_attribute(:venue_verify, Time.now)
        format.html { redirect_to Venue.find(@event.venue_id), notice: 'Hour was successfully created.' }
        format.json { head :no_content }
        format.js { render :layout => false }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
    else
      respond_to do |format|
      if @event.save
        #EventMailer.sample_email(current_user, @event).deliver

        Venue.find(@event.venue_id).update_attribute(:venue_verify, Time.now)
        format.html { redirect_to Venue.find(@event.venue_id), notice: 'Hour was successfully created.' }
        format.json { head :no_content }
        format.js { render :layout => false }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
   
    
        
    respond_to do |format|
      if @event.update(event_params)
        Venue.find(@event.venue_id).update_attribute(:venue_verify, Time.now)
        format.html { redirect_to Venue.find(@event.venue_id), notice: 'Hour was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
        Venue.find(@event.venue_id).venue_avg_verify
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
      Venue.find(@event.venue_id).update_attribute(:venue_verify, Time.now)
      format.html { redirect_to Venue.find(@event.venue_id), notice: 'Event was successfully destroyed.' }
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
      params.require(:event).permit(:special,:detail, :day, :venue_id, :start, :end, :tag_list, :event_verify, :varified_user, :event_date, :food, :drinks, :entertainment, :late_nite, :legit_hour, :credits)
    end
end
