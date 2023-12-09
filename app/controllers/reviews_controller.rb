class ReviewsController < ApplicationController
  before_action :require_login
  def new
    @profile_id = params[:profile_id]
    @profile = Profile.find @profile_id
    @seller_id = @profile.user_id
    @name = @profile.user.full_name

    if Current.user.id == @seller_id.to_i
      flash[:alert] = "You cannot leave a review for yourself."
      redirect_to profile_path(Profile.find_by(user_id: Current.user.id).id)
    else
      unless User.find_by(id: @seller_id).is_seller
        flash[:alert] = "You cannot leave a review for someone who is not a seller."
        redirect_to profile_path(Profile.find_by(user_id: @seller_id))
      end
    end
  end

  def create
    Review.create({reviewer_id: Current.user.id, seller_id: params[:seller_id], has_purchased_from: params[:answer].to_i == 1, interaction_rating: params[:rating].to_i, description: params[:description]})
    # update that seller's seller rating
    average_rating = (User.find params[:seller_id]).reviews_for_sellers.average(:interaction_rating).to_i
    Profile.update(params[:profile_id], seller_rating: average_rating)
    flash[:success] = "Review successfully created!"
    redirect_to profile_path(params[:profile_id])
  end
end
