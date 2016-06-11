class ListsController < ApplicationController
  after_filter "save_my_previous_url", only: [:new]
  before_action :set_list, only: [:show, :edit, :update, :destroy, :add_to_current, :add_to_reserve]
  before_action :authenticate_user!, only: [:new,:show, :edit, :update, :destroy,:add_to_current, :add_to_reserve]
  # GET /lists
  # GET /lists.json
  
  def save_my_previous_url
    # session[:previous_url] is a Rails built-in variable to save last url.
    session[:my_previous_url] = URI(request.referer || '').path
  end
  
  def index
    if (user_signed_in?)
      venue_owner = Venue.where(owner: current_user.id).first.id
      if current_user.id == 1
         @lists = List.all
      else
        @lists = List.where(venue_id: venue_owner)
      end
    end
    if (user_signed_in?)
    @venue_owner = current_user.id
    end
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
  end

  def add_to_current
    @list.update_attribute(:status, "Current")
    redirect_to action: "index", notice: "Beer added to current list"
  end

  def add_to_reserve
    @list.update_attribute(:status, "Reserve")
     redirect_to action: "index", notice: "Beer added to current list"
  end
  # GET /lists/new
  def new
    @list = List.new
    @venue_owner = current_user.id
    @x = []
    @brews = Brew.all
    @back_url = session[:my_previous_url]
  end

  # GET /lists/1/edit
  def edit
     @venue_owner = current_user.id
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        Venue.where(id: @list.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        Venue.where(id: @list.venue_id).first.update_attribute(:venue_verify, Time.now)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      Venue.where(id: @list.venue_id).first.update_attribute(:venue_verify, Time.now)
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    def set_list_total
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:venue_id, :brew_id, :serving_style, :serving_size, :price, :status, :draft_status)
    end
end
