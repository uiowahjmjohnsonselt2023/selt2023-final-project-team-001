class ProfilesController < ApplicationController
  before_action :set_user_and_profile

  def new
    if @profile.present?
      flash[:alert] = "You already have a profile!"
      redirect_to profile_path(id: :show)
    elsif @user.blank?
      flash[:alert] = "You need to sign in before you can create a profile!"
      redirect_to login_path
    end
  end

  def create
    @profile = Profile.new(
      bio: params[:bio],
      location: params[:location],
      first_name: params[:first_name],
      last_name: params[:last_name],
      # birth_date: params[:birth_date],
      # twitter: params[:twitter],
      # facebook: params[:facebook],
      # instagram: params[:instagram],
      # website: params[:website],
      # occupation: params[:occupation],
      # seller_rating: params[:seller_rating],
      # buyer_rating: params[:buyer_rating],
      public_profile: true,
      user_id: session[:user_id]
    )
    if @profile.save
      flash[:notice] = "Profile created successfully!"
      redirect_to profile_path(id: :show)
    else
      flash.now[:alert] = "Profile creation failed. Please check the form."
      render "new"
    end
  end

  def show
    if @user.blank?
      flash[:alert] = "You need to sign in before you can view your profile!"
      redirect_to login_path
    elsif @profile.blank?
      flash[:alert] = "You need to create a profile before you can view it!"
      redirect_to new_profile_path
    end
  end

  def destroy
    @profile.destroy
    flash[:notice] = "Profile deleted successfully!"
    redirect_to root_path
  end

  def delete
    # Render your custom delete confirmation view
  end

  private

  def set_user_and_profile
    @user = User.find_by(id: session[:user_id])
    @profile = @user&.profile
  end
end
