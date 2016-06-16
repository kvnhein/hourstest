class LiqoursController < ApplicationController
  before_action :set_liqour, only: [:show, :edit, :update, :destroy]

  # GET /liqours
  # GET /liqours.json
  def index
    @liqours = Liqour.all
  end

  # GET /liqours/1
  # GET /liqours/1.json
  def show
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
        format.html { redirect_to @liqour, notice: 'Liqour was successfully created.' }
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
        format.html { redirect_to @liqour, notice: 'Liqour was successfully updated.' }
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
    respond_to do |format|
      format.html { redirect_to liqours_url, notice: 'Liqour was successfully destroyed.' }
      format.json { head :no_content }
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
