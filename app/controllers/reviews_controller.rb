class ReviewsController < ApplicationController
  before_action :require_login
  def new
    @profile_id = params[:profile_id]
    @profile = Profile.find @profile_id
    @seller_id = @profile.user_id
    @name = @profile.user.full_name
    reviews_given = Current.user.reviews_user_has_given.where(seller_id: @seller_id).count
    review_cap = 1 + Transaction.where(buyer_id: Current.user.id, seller_id: @seller_id).count
    if Current.user.id == @seller_id.to_i
      flash[:alert] = "You cannot leave a review for yourself."
      redirect_to profile_path(Profile.find_by(user_id: Current.user.id).id)
    else
      unless User.find_by(id: @seller_id).is_seller
        flash[:alert] = "You cannot leave a review for someone who is not a seller."
        redirect_to profile_path(Profile.find_by(user_id: @seller_id))
      end
      if reviews_given > review_cap
        flash[:alert] = "You must purchase from this seller again in order to leave another review!"
        redirect_to profile_path(@profile.id)
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

  def index
    @reviews = Review.where(seller_id: params[:seller_id])
  end
end
