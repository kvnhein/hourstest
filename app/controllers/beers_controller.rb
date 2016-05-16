class BeersController < ApplicationController
  before_action :set_beer, only: [:show, :edit, :update, :destroy, :add_to_current, :add_to_reserve]

  # GET /beers
  # GET /beers.json
  def index
    a = Venue.where(owner: current_user.id).first.id
    @beers = Beer.where(venue_id: a)

    if (user_signed_in?)
      if  current_user.admin?
       @button = 0
     else
       @button = 1
     end
  end
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
  end

  def add_to_current
    @beer.update_attribute(:beer_status, 1)
    redirect_to action: "index", notice: "Beer added to current list"
  end

  def add_to_reserve
    @beer.update_attribute(:beer_status, 2)
     redirect_to action: "index", notice: "Beer added to current list"
  end

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

    respond_to do |format|
      if @beer.save
        format.html { redirect_to @beer, notice: 'Beer was successfully created.' }
        format.json { render :show, status: :created, location: @beer }
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
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer }
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
      params.require(:beer).permit(:name, :brewery, :abv, :genre, :price, :serving, :details, :venue_id)
    end
end
