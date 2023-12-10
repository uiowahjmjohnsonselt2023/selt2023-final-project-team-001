class PromotionsController < ApplicationController
  before_action :require_login
  before_action :require_seller

  def new
    @promotion = Promotion.new
    set_times
  end

  def edit
    @promotion = Promotion.find params[:id]
    set_times
    if Current.user != @promotion.seller && !Current.user.is_admin
      flash[:alert] = "You don't have permission to edit that promotion."
      redirect_to root_path
    end
  end

  private

  def set_times
    @now = Time.now
    @midnight = @now.next_day.midnight
    @week_from_midnight = @midnight.advance weeks: 1
  end
end
