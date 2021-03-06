class BeersController < ApplicationController
  before_filter :require_admin_construction
  before_action :set_beer, only: [:show, :edit, :update, :destroy, :add_to_current, :add_to_reserve, :beer_level_low, :beer_level_full]
  autocomplete :beer, :name, :full => true
  # GET /beers
  # GET /beers.json

  def index

    @beers = Beer.all
    if params[:search]
      @beers = Beer.name_like("%#{params[:search]}%").order('name')
    else
    end

  end

  def venue_beer_list
    if user_signed_in?
      userid = current_user.id
      venue_id = Venue.where(owner: userid).first.id
      @beers = Beer.where(venue_id: venue_id)
    end
    if (user_signed_in?)
    @venue_owner = current_user.id
    end
  end
  # GET /beers/1
  # GET /beers/1.json
  def show
  end

  def add_to_current
    id = @beer.venue_id
    @beer.update_attribute(:beer_status, 2)
    @beers = Beer.where(venue_id: id)

     respond_to do |format|
       format.js    {render :layout => false}
    end
  end

  def add_to_reserve
    id = @beer.venue_id
    @beer.update_attribute(:beer_status, 1)
    @beer.update_attribute(:beer_level, 2)
    @beers =Beer.where(venue_id: id)

    respond_to do |format|
       format.js    {render :layout => false}
    end
  end

  def beer_level_low
    @beer.update_attribute(:beer_level, 1)
      redirect_to action: "venue_beer_list", notice: "Beer level has been changed to 'Low'"
  end

  def beer_level_full
    @beer.update_attribute(:beer_level, 2)
    redirect_to action: "venue_beer_list", notice: "Beer level has been changed to 'high'"
  end

  def

  # GET /beers/new
  def new
    @beer = Beer.new

  end

  # GET /beers/1/edit
  def edit

  end

  # POST /beers
  # POST /beers.json
  def create
    @beer = Beer.new(beer_params)
Venue.where(id: @beer.venue_id).first.update_attribute(:venue_verify, Time.now)
    respond_to do |format|
      if @beer.save

        format.html { redirect_to :venue_beer_list, notice: 'Beer was successfully created.' }
        format.json { render :venue_beer_list, status: :created, location: @beer }
      else
        format.html { render :new }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1
  # PATCH/PUT /beers/1.json
  def update
    respond_to do |format|
      if @beer.update(beer_params)
        Venue.where(id: @beer.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to :venue_beer_list, notice: 'Beer was successfully updated.' }
        format.json { render :venue_beer_list, status: :ok, location: @beer }
      else
        format.html { render :edit }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    @beer.destroy
    respond_to do |format|
      Venue.where(id: @beer.venue_id).first.update_attribute(:venue_verify, Time.now)
      format.html { redirect_to beers_url, notice: 'Beer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer
      @beer = Beer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_params
      params.require(:beer).permit(:name, :brewery, :abv, :genre, :price, :serving, :details, :venue_id, :beer_level, :serving_size)
    end
end
