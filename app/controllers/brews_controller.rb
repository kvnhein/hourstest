class BrewsController < ApplicationController
  #before_filter :require_admin_construction
  before_action :set_brew, only: [:show, :edit, :update, :destroy]

  # GET /brews
  # GET /brews.json
  def index
    
    @neighborhoods = Neighborhood.includes(:venues).all.to_a 
    @users = User.includes(:claims, :events).all.to_a
   
    
    @venues = @neighborhoods.map { |neighborhood| neighborhood.venues.to_a }.flatten
    @events = @users.map { |users| users.events.to_a }.flatten
    @claims = @users.map { |users| users.claims.to_a }.flatten
   
    if (user_signed_in?)
      @signed_in == true
      @current_user = current_user
      @user_likes = @current_user.find_up_voted_items.to_a
    end
    
  end

  # GET /brews/1
  # GET /brews/1.json
  def show
    @list = List.new
    @venue_owner = current_user.id
  end

  # GET /brews/new
  def new
    @brews = Brew.all
    @brew = Brew.new
    respond_to :js
  end

  # GET /brews/1/edit
  def edit
  end

  # POST /brews
  # POST /brews.json
  def create
    @brew = Brew.new(brew_params)

    respond_to do |format|
      if @brew.save
        format.html { redirect_to @brew, notice: 'Brew was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.json { render json: @brew.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brews/1
  # PATCH/PUT /brews/1.json
  def update
    respond_to do |format|
      if @brew.update(brew_params)
        format.html { redirect_to @brew, notice: 'Brew was successfully updated.' }
        format.json { render :show, status: :ok, location: @brew }
      else
        format.html { render :edit }
        format.json { render json: @brew.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brews/1
  # DELETE /brews/1.json
  def destroy
    @brew.destroy
    @brews = Brew.all
    respond_to :js
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brew
      @brew = Brew.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brew_params
      params.require(:brew).permit(:name, :brewery, :detail, :abv, :style)
    end
end
