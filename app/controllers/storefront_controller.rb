class StorefrontController < ApplicationController
  # before_action :authenticate_user! # Assuming you're using Devise for authentication

  def new
    @user = User.find(session[:user_id])
    @products = @user.products
    @storefront = @user.storefront || @user.create_storefront
    @previewed_code = @storefront.custom_code if params[:preview_button]
  end

  def create
    # Add logic to handle the 'Preview Custom Code' action
    if params[:storefront] && params[:preview_button]
      @user = User.find(session[:user_id])
      @products = @user.products
      @storefront = @user.storefront || @user.create_storefront
      @previewed_code = params[:storefront][:custom_code]

      render turbo_stream: turbo_stream.replace(
        "preview_section",
        partial: "preview_section",
        locals: {previewed_code: @previewed_code}
      )
      # render :new
    elsif params[:storefront] && params[:save_button]
      user = User.find(session[:user_id])
      storefront = user.storefront || user.create_storefront
      storefront.update(custom_code: params[:storefront][:custom_code])
      redirect_to storefront_path(storefront)
    end
  end

  def show
    @user = User.find(session[:user_id])
    # @products = @user.products
    @storefront = Storefront.find(params[:id]) # Retrieve the storefront for the current user
    @custom_code = @storefront&.custom_code || "" # Fetch custom code or default to empty string
  end
end
