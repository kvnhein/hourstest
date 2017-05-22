class ReviewsController < ApplicationController
    
    def create
        @review = current_user.reviews.create(review_params)
        redirect_to @review.event
    end
    
    def destroy
        @review = Review.find(params[:id])
        event = @review.event
        @review.destroy
    end 
    
    private
    def review_params
        params.require(:review).permit(:comment, :star, :event_id)
    end 
end
