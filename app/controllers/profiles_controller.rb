class ProfilesController < ApplicationController
  before_action :set_user_and_profile

  def new
    if @profile.present?
      flash[:alert] = "You already have a profile!"
      redirect_to profile_path(@profile)
    elsif @user.blank?
      flash[:alert] = "You need to sign in before you can create a profile!"
      redirect_to login_path
    end
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = @user
    if @profile.save
      flash[:notice] = "Profile created successfully!"
      redirect_to profile_path(@profile)
    else
      flash.now[:alert] = "Profile creation failed. Please check the form."
      render "new"
    end
  end

  def show
    @my_profile = (params[:id].to_i == @profile.id)
    @profile_requested = Profile.find_by(id: params[:id])
    if @profile_requested.blank?
      flash[:alert] = "This profile does not exist!"
      redirect_to root_path
    elsif !@profile_requested.public_profile && !@my_profile
      flash[:alert] = "This profile is private!"
      redirect_to root_path
    end
  end

  def destroy
    if params[:id].to_i != @profile.id
      flash[:alert] = "You can only delete your own profile!"
      redirect_to root_path and return
    elsif @profile.blank?
      flash[:alert] = "You don't have a profile to delete!"
      redirect_to root_path and return
    end
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

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :bio, :location, :twitter, :facebook, :instagram, :website, :occupation, :public_profile)
  end
end
