class VenuesController < ApplicationController
  before_action :set_venue, only: [:show, :edit, :update, :destroy, :venue_verified]
  before_action :require_admin, only: [:destroy, :new]
  before_action :require_owner, only: [:edit, :update]


  # GET /venues
  # GET /venues.json
  def index
    @venues = Venue.all

  end

  def users_venues
    if user_signed_in?
    a = current_user.id
    @venues = Venue.where(owner: a)
    end
  end
  def venue_verified
    @venue.update_attribute(:venue_verify, Time.now)
    redirect_to action: "show", notice: "You are verified!"
  end
  # GET /venues/1
  # GET /venues/1.json
  def show

    @events = Event.where(venue_id: params[:id])
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


    @lists = Beer.where(venue_id: params[:id])
    @liquors = Liqour.where(venue_id: params[:id])
    @daily_specials = DailySpecial.where(venue_id: params[:id])
    @drinks = Drink.where(venue_id: params[:id])
    



    if (user_signed_in?)
     if current_user.id == @venue.owner || current_user.admin?
       @button = 1
     else
       @button = 0
     end
   end

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
      params.require(:venue).permit(:name, :address, :longitude, :latitude, :neighborhood_id, :owner, :menu_address, :phone_number, :genre)
    end
end
