class DrinksController < ApplicationController
  before_action :set_drink, only: [:show, :edit, :update, :destroy, :add_to_current, :add_to_reserve]

  # GET /drinks
  # GET /drinks.json
  def index
    @drinks = Drink.all
  end

  # GET /drinks/1
  # GET /drinks/1.json
  def show
  end

  def add_to_current
    @drink.update_attribute(:drink_Status, "Current")
    redirect_to action: "index", notice: "Drink added to current list"
  end

  def add_to_reserve
    @drink.update_attribute(:drink_Status, "Reserve")
     redirect_to action: "index", notice: "Drink added to current list"
  end
  # GET /drinks/new
  def new
    @drink = Drink.new
  end

  # GET /drinks/1/edit
  def edit
  end

  # POST /drinks
  # POST /drinks.json
  def create
    @drink = Drink.new(drink_params)

    respond_to do |format|
      if @drink.save
        Venue.where(id: @drink.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to @drink, notice: 'Drink was successfully created.' }
        format.json { render :show, status: :created, location: @drink }
      else
        format.html { render :new }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drinks/1
  # PATCH/PUT /drinks/1.json
  def update
    respond_to do |format|
      if @drink.update(drink_params)
        Venue.where(id: @drink.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to @drink, notice: 'Drink was successfully updated.' }
        format.json { render :show, status: :ok, location: @drink }
      else
        format.html { render :edit }
        format.json { render json: @drink.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drinks/1
  # DELETE /drinks/1.json
  def destroy
    @drink.destroy
    respond_to do |format|
      Venue.where(id: @drink.venue_id).first.update_attribute(:venue_verify, Time.now)
      format.html { redirect_to drinks_url, notice: 'Drink was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_drink
      @drink = Drink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def drink_params
      params.require(:drink).permit(:name, :description, :price, :drink_Status, :drink_type, :venue_id)
    end
end