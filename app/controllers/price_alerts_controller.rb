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

  def edit
    @price_alert = PriceAlert.find(params[:id])
    @product = Product.find(params[:product_id])
  end

  def update
    @price_alert = PriceAlert.find(params[:id])
    if @price_alert.update(threshold: params[:new_threshold])
      redirect_to @price_alert
    else
      flash[:alert] = "Please fix the errors below."
      render "edit"
    end
  end

  def index
    @price_alerts = Current.user.price_alerts # Assuming the association is set correctly
  end

  def show
    @price_alert_item = PriceAlert.find(params[:id])
  end
end
