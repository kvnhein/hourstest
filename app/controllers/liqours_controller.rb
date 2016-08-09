class LiqoursController < ApplicationController
  before_action :set_liqour, only: [:show, :edit, :update, :destroy, :add_to_current, :add_to_reserve]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  # GET /liqours
  # GET /liqours.json
  def index
    @liqours = Liqour.all
  end

  # GET /liqours/1
  # GET /liqours/1.json
  def show
  end

  def add_to_current
    @liqour.update_attribute(:drink_Status, "Current")
    redirect_to action: "index", notice: "Liquor added to current list"
  end

  def add_to_reserve
    @liqour.update_attribute(:liqour_Status, "Reserve")
     redirect_to action: "index", notice: "Liquor added to current list"
  end
  # GET /liqours/new
  def new
    @liqour = Liqour.new
  end

  # GET /liqours/1/edit
  def edit
  end

  # POST /liqours
  # POST /liqours.json
  def create
    @liqour = Liqour.new(liqour_params)

    respond_to do |format|
      if @liqour.save
        Venue.where(id: @liqour.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to @liqour, notice: 'Liquor was successfully created.' }
        format.json { render :show, status: :created, location: @liqour }
      else
        format.html { render :new }
        format.json { render json: @liqour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /liqours/1
  # PATCH/PUT /liqours/1.json
  def update
    respond_to do |format|
      if @liqour.update(liqour_params)
        Venue.where(id: @liqour.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to @liqour, notice: 'Liquor was successfully updated.' }
        format.json { render :show, status: :ok, location: @liqour }
      else
        format.html { render :edit }
        format.json { render json: @liqour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /liqours/1
  # DELETE /liqours/1.json
  def destroy
    @liqour.destroy
    @liqours = Liqour.all
     Venue.where(id: @liqour.venue_id).first.update_attribute(:venue_verify, Time.now)
    respond_to do |format|
      format.html { redirect_to liqours_url, notice: 'Liquor was successfully destroyed.' }
      format.json { head :no_content }
      format.js    {render :layout => false}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_liqour
      @liqour = Liqour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def liqour_params
      params.require(:liqour).permit(:name, :description, :distillery, :liqour_status, :liqour_type, :price, :venue_id)
    end
end
