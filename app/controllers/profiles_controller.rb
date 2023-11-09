class ProfilesController < ApplicationController
  before_action :set_user_and_profile, only: [:show]

  def show
    unless @user.present? && @profile.present?
      flash[:alert] = "User profile not found."
      redirect_to root_path
    end
  end

  private

  def set_user_and_profile
    @user = User.find_by(id: session[:user_id])
    @profile = @user&.profile
  end
end
