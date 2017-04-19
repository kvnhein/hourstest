class VenuesController < ApplicationController
  before_action :set_venue, only: [:show, :edit, :update, :destroy, :venue_verified]
  before_action :require_admin, only: [:destroy, :new]
  before_action :require_owner, only: [:edit, :update]


  # GET /venues
  # GET /venues.json
  def index
   @neighborhoods = Neighborhood.all_cached.to_a

    @venue_array = @venues.all_cached.order("name ASC").to_a
  end

  def users_venues
    if user_signed_in?
    a = current_user.id
    @venues = Venue.where(owner: a)
    end
  end
  
  def venue_verified
    @venue.update_attribute(:venue_verify, Time.now)
    current_user.increment!(:experience)
    redirect_to action: "show", notice: "You are verified!"
  end
  
  # GET /venues/1
  # GET /venues/1.json
  
  def show
    @topic = "at #{@venue.name}"
    @topic_description = "Check out today's Happy Hours/Specials and Featured Dishes at #{@venue.name}"
    @page_image = DailySpecial.today.where(venue_id: params[:id]).first
    @claims = Claim.all
    #if DailySpecial.before(Date.today - 7).count > 0
    #past_specials = DailySpecial.before(Date.today - 7)
    #past_specials.delete_all
    #end
    @current_user = current_user
    @event = Event.new 
    @events_all = Event.where(venue_id: @venue.id).to_a
    @events_id = @events_all.map { |event| event.id }
    if (user_signed_in?)
    @user_likes = @events_all.select{|event| event.cached_votes_up > 0}.select{|event| @current_user.voted_as_when_voted_for event}.map{|event| event.id}  
    end
    @users = User.all.to_a
    
    if @events_id.count > 0
     @claims_all = Claim.all.to_a.select { |claim| @events_id.include?(claim.id)}
     @claims_event_id = @claims_all.map {|claim| claim.event_id}
    else
      @claims_all = []
      @claims_event_id = []
    end
    
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
    @daily_specials = DailySpecial.where(venue_id: @venue.id)
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
