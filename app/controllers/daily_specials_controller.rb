class DailySpecialsController < ApplicationController
  before_action :set_daily_special, only: [:show, :edit, :update, :destroy]

  # GET /daily_specials
  # GET /daily_specials.json
  def index
    @daily_specials = DailySpecial.all
  end

  # GET /daily_specials/1
  # GET /daily_specials/1.json
  def show
  end

  # GET /daily_specials/new
  def new
    @daily_special = DailySpecial.new
  end

  # GET /daily_specials/1/edit
  def edit
  end

  # POST /daily_specials
  # POST /daily_specials.json
  def create
    @daily_special = DailySpecial.new(daily_special_params)

    respond_to do |format|
      if @daily_special.save
        format.html { redirect_to @daily_special, notice: 'Daily special was successfully created.' }
        format.json { render :show, status: :created, location: @daily_special }
      else
        format.html { render :new }
        format.json { render json: @daily_special.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /daily_specials/1
  # PATCH/PUT /daily_specials/1.json
  def update
    respond_to do |format|
      if @daily_special.update(daily_special_params)
        format.html { redirect_to @daily_special, notice: 'Daily special was successfully updated.' }
        format.json { render :show, status: :ok, location: @daily_special }
      else
        format.html { render :edit }
        format.json { render json: @daily_special.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_specials/1
  # DELETE /daily_specials/1.json
  def destroy
    @daily_special.destroy
    respond_to do |format|
      format.html { redirect_to daily_specials_url, notice: 'Daily special was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_special
      @daily_special = DailySpecial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def daily_special_params
      params.require(:daily_special).permit(:text, :description, :price, :venue_id, :dish_type)
    end
end
