class VenuesController < ApplicationController
  before_action :set_venue, only: [:show, :edit, :update, :destroy, :venue_verified, :upvote, :downvote]
  before_action :require_admin, only: [:destroy, :new]
  before_action :require_owner, only: [:edit, :update]


  # GET /venues
  # GET /venues.json
  def index
   @neighborhoods = Neighborhood.all_cached.to_a

    @venue_array = @venues.all_cached.order("name ASC").to_a
  end


  def venue_dash
  end 
  
  def venues_avg_time
    venues = Venue.all.to_a
    venues.each {|venue| venue.avg_time}
    @venues = venues.sort! {|x,y| y.avg_verify <=> x.avg_verify }
  end
  
  
  def upvote
  @venue.liked_by current_user
  end

  def downvote
  @venue.unliked_by current_user
  end
  
  
  def venue_verified
    @venue.update_attribute(:venue_verify, Time.now)
    current_user.increment!(:experience)
    redirect_to action: "show", notice: "You are verified!"
  end
  
  # GET /venues/1
  # GET /venues/1.json
  
  def show
    if (user_signed_in?)
        @signed_in = true
        @user_likes = current_user.find_up_voted_items.to_a
    else
        @signed_in = false
    end
    @daily_specials = DailySpecial.all.to_a.select{|special| special.venue_id == @venue.id}.sort!{|x,y| x.created_at <=> y.created_at }
    @current_voter = current_user
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    @topic = "at #{@venue.name}"
    @topic_description = "Check out today's Happy Hours/Specials and Featured Dishes at #{@venue.name}"
    @page_image = @daily_specials.first
    @claims = Claim.all
    #if DailySpecial.before(Date.today - 7).count > 0
    #past_specials = DailySpecial.before(Date.today - 7)
    #past_specials.delete_all
    #end
    @current_user = current_user
    @event = Event.new 
    @events_all = Event.where(venue_id: @venue.id).to_a
    @events_id = @events_all.map { |event| event.id }
    
    @users = User.all.to_a
    

     @claims_all = Claim.all.to_a
     
    
    
    t= Time.now.in_time_zone("Eastern Time (US & Canada)")
    @m = ""
    @t = ""
    @w = ""
    @th = ""
    @f = ""
    @s = ""
    @st = ""
    @button = 0
    if t.wday == 1
      @m = "active"
    elsif  t.wday==2
      @t = "active"
    elsif  t.wday==3
      @w = "active"
    elsif  t.wday==4
      @th = "active"
    elsif  t.wday==5
      @f = "active"
    elsif  t.wday==6
      @st = "active"
     else
      @s = "active"
    end
    
   
      @claims_all.each do |claim|
        if claim.delete_date == Date.current
          claim.destroy!
          event.destroy!
        end 
      end 
   

    @beers = Beer.where(venue_id: @venue.id) #did this so no beer list would show
    @liquors = Liqour.where(venue_id: params[:id])
    #@daily_specials = DailySpecial.where(venue_id: @venue.id)
    @drinks = Drink.where(venue_id: params[:id])



    if (user_signed_in?)
     if current_user.id == @venue.owner || current_user.admin?
       @button = 1
     elsif current_user.experience > 10000
      @button = 1
    else
       @button = 0
     end
     
    
   end

      @venue_features = DailySpecial.today
  end

  # GET /venues/new
  def new
    @venue = Venue.new
  end

  # GET /venues/1/edit
  def edit
  end

  # POST /venues
  # POST /venues.json
  def create
    @venue = Venue.new(venue_params)

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
        format.json { render :show, status: :created, location: @venue }
      else
        format.html { render :new }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /venues/1
  # PATCH/PUT /venues/1.json
  def update
    respond_to do |format|
      if @venue.update(venue_params)

        format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
        format.json { render :show, status: :ok, location: @venue }
      else
        format.html { render :edit }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /venues/1
  # DELETE /venues/1.json
  def destroy
    @venue.destroy
    respond_to do |format|
      format.html { redirect_to venues_url, notice: 'Venue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venue
      @venue = Venue.find(params[:id])

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venue_params
      params.require(:venue).permit(:name, :address, :longitude, :latitude, :neighborhood_id, :owner, :menu_address, :phone_number, :genre, :urbanist, :open_table_id,:spr_rank)
    end
end
