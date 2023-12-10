class PromotionsController < ApplicationController
  before_action :require_login
  before_action :require_seller

  def new
    @promotion = Promotion.new
  end

  def edit
    @promotion = Promotion.find params[:id]
    if Current.user != @promotion.seller && !Current.user.is_admin
      flash[:alert] = "You don't have permission to edit that promotion."
      redirect_to root_path
    end
  end
end
