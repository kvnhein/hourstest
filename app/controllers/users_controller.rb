class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		@daily_specials = DailySpecial.where(user_id: @user.id)
	end
	
	
end