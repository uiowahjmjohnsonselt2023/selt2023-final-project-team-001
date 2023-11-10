class ProfilesController < ApplicationController
  before_action :set_user_and_profile

  def edit
    # Render the edit form
    if @profile.blank?
      flash[:alert] = "You don't have a profile to edit!"
      redirect_to new_profile_path and return
    elsif params[:id].to_i != @profile.id
      flash[:alert] = "You can only edit your own profile!"
      redirect_to root_path and return
    end
  end

  def update
    if @profile.blank?
      flash[:alert] = "You don't have a profile to edit!"
      redirect_to new_profile_path and return
    elsif params[:id].to_i != @profile.id
      flash[:alert] = "You can only edit your own profile!"
      redirect_to root_path and return
    end
    if @profile.update(profile_params)
      redirect_to @profile, notice: "Profile was successfully updated."
    else
      flash.now[:alert] = "Profile update failed. Please check the form."
      render :edit
    end
  end

  def new
    if @profile.present?
      flash[:alert] = "You already have a profile!"
      redirect_to profile_path(@profile)
    elsif @user.blank?
      flash[:alert] = "You need to sign in before you can create a profile!"
      redirect_to login_path and return
    end
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = @user
    @profile.avatar = params[:profile][:avatar] # Make sure to permit this in your strong params
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

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :bio, :location, :twitter, :facebook, :instagram, :website, :occupation, :public_profile, :avatar)
  end
end
