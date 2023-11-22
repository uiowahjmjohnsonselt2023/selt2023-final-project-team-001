class StorefrontController < ApplicationController
  before_action :require_login, except: [:show] # , :index]

  def new
    @products = Current.user.products
    @storefront = Current.user.storefront || Current.user.create_storefront
    @previewed_code = @storefront.custom_code if params[:preview_button]
  end

  def create
    # Add logic to handle the 'Preview Custom Code' action
    if params[:storefront] && params[:preview_button]
      @products = Current.user.products
      @storefront = Current.user.storefront || Current.user.create_storefront
      @previewed_code = params[:storefront][:custom_code]

      render turbo_stream: turbo_stream.replace(
        "preview_section",
        partial: "preview_section",
        locals: {previewed_code: @previewed_code}
      )
      # render :new
    elsif params[:storefront] && params[:save_button]
      storefront = Current.user.storefront || Current.user.create_storefront
      storefront.update(custom_code: params[:storefront][:custom_code])
      redirect_to storefront_path(storefront)
    end
  end

  def show
    @storefront = Storefront.find(params[:id])
    @user = @storefront.user
    @products = @user.products
    @custom_code = @storefront&.custom_code || "" # Fetch custom code or default to empty string
  end
end
