class PromotionsController < ApplicationController
  before_action :require_login
  before_action :require_seller

  def new
    @promotion = Promotion.new
  end
end
