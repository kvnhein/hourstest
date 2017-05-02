class ClaimsController < ApplicationController
  before_action :set_claim, only: [:show, :edit, :update, :destroy, :claim_downvote, :claim_upvote]


  # GET /claims
  # GET /claims.json
  def index
    @claims = Claim.all
    
  end

  # GET /claims/1
  # GET /claims/1.json
  def show
  end

  # GET /claims/new
  def new
    @claim = Claim.new
  end

  def claim_upvote
    @claim.liked_by current_user
    current_user.increment!(:experience,by = 5)
    current_user.increment!(:num_claim_votes,by = 1)
    if @claim.claim_votes >= 10 
       @claim.status = 1 
       @claim.delete_date = Date.tomorrow
       @claim.save!
    end
  end

  def claim_downvote
    @claim.disliked_by current_user
    current_user.decrement!(:experience,by = 5)
    current_user.decrement!(:num_claim_votes,by = 1)
    if @claim.claim_votes <10 
      @claim.status = 0
      @claim.delete_date = Date.yesterday
      @claim.save!
    end
  end

  # GET /claims/1/edit
  def edit
  end

  # POST /claims
  # POST /claims.json
  def create
    @claim = Claim.create! claim_params
    @claim.event.event_verify = Time.now 
    @claim.event.save! 
    current_user.increment!(:experience,by = 15 )
  respond_to do |format|
    format.html { redirect_to action: :index }
    format.js
  end
  end

  def event_create
    @claim = Claim.create! claim_params
   
    
  respond_to do |format|
    format.html { redirect_to action: :index }
    format.js
  end
  end
  
  # PATCH/PUT /claims/1
  # PATCH/PUT /claims/1.json
  def update
    respond_to do |format|
      if @claim.update(claim_params)
        format.html { redirect_to @claim, notice: 'Claim was successfully updated.' }
        format.json { render :show, status: :ok, location: @claim }
      else
        format.html { render :edit }
        format.json { render json: @claim.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /claims/1
  # DELETE /claims/1.json
  def destroy
    @modal_id = @claim.event_id
    @modal_event = @claim.event
    @claim.destroy
    current_user.decrement!(:experience,by = 15 )
    respond_to do |format|
      format.html { redirect_to claims_url, notice: 'Claim was successfully destroyed.' }
      format.json { head :no_content }
      format.js { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  
    def set_claim
      @claim = Claim.find(params[:id])
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def claim_params
      params.require(:claim).permit(:user_id, :event_id, :description)
    end
end
