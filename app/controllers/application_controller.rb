class ApplicationController < ActionController::Base
  attr_accessor :current_user
  protect_from_forgery

  protected

  def set_current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    redirect_to login_path unless @current_user
  end

  def current_user?(id)
    @current_user.id.to_s == id
  end
end
