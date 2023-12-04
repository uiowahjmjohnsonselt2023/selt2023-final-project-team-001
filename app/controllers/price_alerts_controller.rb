class PriceAlertsController < ApplicationController
  before_action :require_login

  def new
    @product = Product.find(params[:product_id])
  end

  def create
    @product = Product.find(params[:product_id])

    @price_alert = PriceAlert.new(product: @product, user: Current.user, threshold: params[:new_threshold])

    if @price_alert.save
      redirect_to @price_alert
    else
      flash[:alert] = "Please fix the errors below."
      render "new", status: :unprocessable_entity
    end
  end

  def index
    @price_alerts = Current.user.price_alerts # Assuming the association is set correctly
  end

  def show
    @price_alert_item = PriceAlert.find(params[:id])
  end
end
