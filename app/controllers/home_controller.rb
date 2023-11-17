class HomeController < ApplicationController
  def index
    set_user_and_profile
  end

  private

  def set_user_and_profile
    @user = User.find_by(id: session[:user_id])
    @profile = @user&.profile
    @storefront = @user&.storefront
  end
end
