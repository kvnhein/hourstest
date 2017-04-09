class UsersController < ApplicationController
	
	 before_action :set_user, only: [:add_super_user, :remove_super_user] 
	def show
		@user = User.find(params[:id])
		@daily_specials = DailySpecial.where(user_id: @user.id).page(params[:page]).per_page(5)
	end
	
	def special_collection
		@key_special = DailySpecial.find(params[:id])
		@collection_user = User.find(@key_special.id)
		@daily_specials = DailySpecial.where(user_id: @key_special.user_id, venue_id: @key_special.venue_id).page(params[:page]).per_page(5)
	end 
	
	def user_list
		@top_user = User.users_cached
	end
	
	
	
	def add_super_user
    	
    	@user.update_attribute(:experience, 11000)
    	@users = User.all
	end
  
  def remove_super_user
    
    @user.update_attribute(:feature_rights, false)
    @users = User.all

     respond_to do |format|
       format.js    {render :layout => false}
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

end