class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		@daily_specials = DailySpecial.where(user_id: @user.id)
	end
	
	def special_collection
		@key_special = DailySpecial.find(params[:id])
		@collection_user = User.find(@key_special.id)
		@daily_specials = DailySpecial.where(user_id: @key_special.user_id, venue_id: @key_special.venue_id)
	end 
	
end