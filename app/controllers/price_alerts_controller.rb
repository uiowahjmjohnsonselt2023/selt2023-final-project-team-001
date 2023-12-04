class PriceAlertsController < ApplicationController
  before_action :require_login

  def new
    if PriceAlert.exists?(product_id: params[:product_id], user_id: Current.user.id)
      price_alert = PriceAlert.find_by(product_id: params[:product_id], user_id: Current.user.id)
      flash[:alert] = t("price_alerts.new.already_exists")
      redirect_to price_alert_path(price_alert.id)
    end
    @product = Product.find(params[:product_id])
  end

  def create
    @product = Product.find(params[:product_id])
    @price_alert = PriceAlert.new(product: @product, user: Current.user, threshold: params[:new_threshold])

    if @price_alert.save
      flash.now[:notice] = t("price_alerts.create.success")
      redirect_to @price_alert
    else
      flash[:alert] = t("price_alerts.create.failure")
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @price_alert = PriceAlert.find(params[:id])
  end

  def update
    puts(params[:price_alert][:new_threshold])

    @price_alert = PriceAlert.find(params[:id])
    if @price_alert.update(threshold: params[:price_alert][:new_threshold])
      flash[:notice] = t("price_alerts.update.success")
      redirect_to @price_alert
    else
      flash.now[:alert] = t("price_alerts.update.failure")
      render "edit"
    end
  end

  def index
    @price_alerts = Current.user.price_alerts # Assuming the association is set correctly
  end

  def show
    @price_alert_item = PriceAlert.find(params[:id])
  end

  def destroy
    @price_alert = PriceAlert.find(params[:id])
    if @price_alert.destroy
      flash[:notice] = t("price_alerts.destroy.success")
      redirect_to price_alerts_path
    else
      flash.now[:alert] = t("price_alerts.destroy.failure")
      render "delete"
    end
  end

  def delete
    @price_alert = PriceAlert.find(params[:id])
  end
end
