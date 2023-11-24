class StorefrontsController < ApplicationController
  before_action :require_login, except: [:show]
  before_action :require_seller, only: [:new, :create, :new_storefront_with_template, :choose_template]

  def new
    @products = Current.user.products
    @storefront = Current.user.storefront || Current.user.create_storefront
    @previewed_code = @storefront.custom_code if params[:preview_button]
  end

  def new_storefront_with_template
    render "new_storefront_with_template"
  end

  def create
    # Add logic to handle the 'Preview Custom Code' action
    if params[:storefront] && params[:preview_button]
      @products = Current.user.products
      @storefront = Current.user.storefront || Current.user.create_storefront
      @previewed_code = params[:storefront][:custom_code]
      flash.now[:notice] = t("storefronts.preview.success")
      render :new
    elsif params[:storefront] && params[:save_button]
      storefront = Current.user.storefront || Current.user.create_storefront
      if storefront.update(custom_code: params[:storefront][:custom_code])
        flash[:notice] = t("storefronts.update.success")
        redirect_to storefront_path(storefront) and return
      else
        flash[:alert] = t("storefronts.update.failure")
        redirect_to root_path and return
      end
    end
  end

  def choose_template
    template_number = params[:template_number]
    storefront = Current.user.storefront || Current.user.create_storefront
    if storefront.update(custom_code: template_number)
      flash[:notice] = t("storefronts.update.success")
    else
      flash[:alert] = t("storefronts.update.failure")
    end
    redirect_to storefront_path(storefront) and return
  end

  def show
    @storefront = Storefront.find(params[:id])
    @user = @storefront.user
    @products = @user.products
    if @storefront.custom_code == "1"
      render :template1 and return
    elsif @storefront.custom_code == "2"
      render :template2 and return
    end
    @custom_code = @storefront&.custom_code || "" # Fetch custom code or default to empty string

    respond_to do |format|
      format.html do
        headers["Content-Type"] = "text/html"
        render :show
      end
    end
  end

  private

  def require_seller
    unless Current.user.is_seller || Current.user.is_admin
      flash[:alert] = i18n_t scope: :require_seller
      redirect_to root_path
    end
  end
end