class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    review = Review.new(review_params)
    review.user = current_user
    review.medium = Medium.find(params[:medium_id])
    review.save

    redirect_to discover_path
  end

  private

  def review_params
    params.require(:review).permit(:title, :description)
  end
end
