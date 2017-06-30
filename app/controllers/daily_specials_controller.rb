class DailySpecialsController < ApplicationController
 # before_filter :require_admin_construction
  before_action :set_daily_special, only: [:show, :edit, :update, :destroy, :dish_limited, :dish_not_limited,:upvote, :downvote]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy,:upvote, :downvote]

  # GET /daily_specials
  # GET /daily_specials.json
  def underconstruction
  end
  
  def index
  @page_url = "daily_specials"
  @topic = "Featured Dishes"
  @topic_description = "Today's best off menu dishes from around Pittsburgh"
  if params[:tag]
    #@daily_specials = DailySpecial.tagged_with(params[:tag])
    @daily_specials = DailySpecial.where(special_date: Date.current).tagged_with(params[:tag])
    @topic = "##{params[:tag]}"
  else
     @topic = ""
     #@daily_specials = DailySpecial.all
     @daily_specials = DailySpecial.where(special_date: Date.current)
    fresh_when etag: @daily_specials

  end
  
  increase_array = [0,0,0,0,0,1,2,1,1]
   @daily_specials.to_a.each do |feature|
     if feature.credit > 0 
        feature_increase = (feature.credit*increase_array[rand(0..8)])/feature.credit
        feature.increment!(:credit, by = feature_increase)
      end
    end 
  end

  def add_reservation
  end
  
  def past_features
    @page_url = "daily_specials"
    @topic = "Featured Dishes"
    @topic_description = "Today's best off menu dishes from around Pittsburgh"
    if params[:past_tag]
      @daily_specials = DailySpecial.tagged_with(params[:past_tag])
      @topic = "##{params[:past_tag]}"
    else
      @daily_specials = DailySpecial.after(Date.today - 7)
      @topic = ""
    end
  end

  def upvote
  @daily_special.liked_by current_user
  current_user.count_features_liked
  end

  def downvote
  @daily_special.unliked_by current_user

  end
  # GET /daily_specials/1
  # GET /daily_specials/1.json
  def show
    @reservation = Reservation.new
    @key_special = DailySpecial.find(params[:id])
		@collection_user = User.find(@key_special.id)
		@daily_specials = DailySpecial.where(user_id: @key_special.user_id, venue_id: @key_special.venue_id)
  end

  # GET /daily_specials/new
  def new
    @daily_special = current_user.daily_specials.build
  end

  # GET /daily_specials/1/edit
  def edit
  end

  # POST /daily_specials
  # POST /daily_specials.json
  def create
    @daily_special = current_user.daily_specials.build(daily_special_params)

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
      params.require(:daily_special).permit(:text, :description, :price, :venue_id, :dish_type, :dish_status, :start, :end, :day, :image, :credit, :tag_list, :available_credits, :special_date)
    end
end
