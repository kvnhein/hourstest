class DailySpecialsController < ApplicationController
  before_action :set_daily_special, only: [:show, :edit, :update, :destroy, :dish_limited, :dish_not_limited,:upvote, :downvote]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy,:upvote, :downvote]

  # GET /daily_specials
  # GET /daily_specials.json
  def index
  @page_url = "daily_specials"
  @topic = "Featured Dishes"
  @topic_description = "Today's best off menu dishes from around Pittsburgh"
  if params[:tag]
    @daily_specials = DailySpecial.tagged_with(params[:tag])
  else
    @daily_specials = DailySpecial.all

  end

  end

  def upvote
  @daily_special.liked_by current_user

  end

  def downvote
  @daily_special.unliked_by current_user

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
        Venue.where(id: @daily_special.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to Venue.where(id: @daily_special.venue_id).first, notice: 'Daily special was successfully created.' }
        format.json { render :show, status: :created, location: @daily_special }

      else
        format.html { render :new }
        format.json { render json: @daily_special.errors, status: :unprocessable_entity }
      end
    end
  end
  def dish_limited
    @dailyspecial.update_attribute(:dish_status, "limited")
    redirect_to action: "index", notice: "Special's status has been changed to 'Limited'"
  end

  def dish_not_limited
    @dailyspecial.update_attribute(:dish_status, "not limited")
    redirect_to action: "index", notice: "Special's status has been changed to 'Not Limited'"
  end
  # PATCH/PUT /daily_specials/1
  # PATCH/PUT /daily_specials/1.json
  def update
    respond_to do |format|
      if @daily_special.update(daily_special_params)
        Venue.where(id: @daily_special.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to Venue.where(id: @daily_special.venue_id).first, notice: 'Daily special was successfully updated.' }
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
    id = @daily_special.venue_id
    @daily_special.destroy
    @daily_specials = DailySpecial.where(venue_id: id)
    Venue.where(id: @daily_special.venue_id).first.update_attribute(:venue_verify, Time.now)
    respond_to do |format|
      format.html { redirect_to Venue.where(id: @daily_special.venue_id).first, notice: 'Daily special was successfully destroyed.' }
      format.json { head :no_content }
      format.js { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_special
      @daily_special = DailySpecial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def daily_special_params
      params.require(:daily_special).permit(:text, :description, :price, :venue_id, :dish_type, :dish_status, :start, :end, :day, :image, :credit, :tag_list)
    end
end
