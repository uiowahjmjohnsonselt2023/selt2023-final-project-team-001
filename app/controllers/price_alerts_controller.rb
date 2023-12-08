class PriceAlertsController < ApplicationController
  before_action :require_login

  def new
    if PriceAlert.exists?(product_id: params[:product_id], user_id: Current.user.id)
      PriceAlert.find_by(product_id: params[:product_id], user_id: Current.user.id)
      flash[:alert] = t("price_alerts.new.already_exists")
      redirect_to price_alerts_path
    elsif Current.user.products.present? && Current.user.products.ids.include?(params[:product_id].to_i)
      flash[:alert] = t("price_alerts.new.cannot_add_own_product")
      redirect_to root_path
    else
      @price_alert = PriceAlert.new
    end
    @product = Product.find(params[:product_id])
  end

  def create
    @product = Product.find(params[:product_id])
    @price_alert = PriceAlert.new(product: @product, user: Current.user, threshold: params[:new_threshold])

    if @price_alert.save
      flash.now[:notice] = t("price_alerts.create.success")
      redirect_to price_alerts_path
    else
      flash[:alert] = t("price_alerts.create.failure")
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @price_alert = PriceAlert.find(params[:id])
    if @price_alert.user != Current.user
      flash[:alert] = t("price_alerts.edit.not_yours")
      redirect_to root_path
    end
  end

  def update
    @price_alert = PriceAlert.find(params[:id])
    if @price_alert.user != Current.user
      flash[:alert] = t("price_alerts.update.not_yours")
      redirect_to root_path
    elsif @price_alert.update(threshold: params[:price_alert][:new_threshold])
      flash[:notice] = t("price_alerts.update.success")
      redirect_to price_alerts_path
    else
      flash[:alert] = t("price_alerts.update.failure")
      redirect_to root_path
    end
  end

  def index
    @price_alerts = Current.user.price_alerts
  end

  def destroy
    if PriceAlert.exists?(id: params[:id], user_id: Current.user.id)
      @price_alert = PriceAlert.find(params[:id])
      if @price_alert.destroy
        flash[:notice] = t("price_alerts.destroy.success")
        redirect_to price_alerts_path
      else
        flash[:alert] = t("price_alerts.destroy.failure")
        redirect_to root_path
      end
    else
      flash[:alert] = t("price_alerts.destroy.not_yours")
      redirect_to root_path
    end
  end

  def delete
    if PriceAlert.exists?(id: params[:id], user_id: Current.user.id)
      @price_alert = PriceAlert.find(params[:id])
    else
      flash[:alert] = t("price_alerts.delete.not_yours")
      redirect_to root_path
    end
  end
end
