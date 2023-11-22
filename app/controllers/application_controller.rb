class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_current_user

  def set_current_user
    Current.user = User.find_by(id: session[:user_id])
  end

  protected

  def require_login
    redirect_to login_path unless Current.user
  end
end
