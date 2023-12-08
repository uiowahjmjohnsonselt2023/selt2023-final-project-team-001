class ProfilesController < ApplicationController
  before_action :require_login, except: [:show]
  before_action :require_not_seller, only: [:destroy, :delete]

  def edit
    @profile = Current.user.profile
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
    @profile = Current.user.profile
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
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    if Current.user.profile.present?
      flash[:alert] = "You already have a profile!"
      redirect_to profile_path(Current.user.profile)
    end
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = Current.user
    @profile.avatar = params[:profile][:avatar] # Make sure to permit this in your strong params
    if @profile.save
      flash[:notice] = "Profile created successfully!"
      redirect_to profile_path(@profile)
    else
      # Need to set user to nil because otherwise the navbar/_user_dropdown partial
      # sees the profile and tries to render a link to it, but profile.id is nil.
      @profile.user = nil
      flash.now[:alert] = "Profile creation failed. Please check the form."
      render "new", status: :unprocessable_entity
    end
  end

  def show
    @profile = Profile.find params[:id] # renders 404 if nonexistent
    @is_current_user = Current.user&.profile == @profile
    @is_seller = (User.find @profile.user_id).is_seller
    @show_links = User.find_by(id: @profile.user_id)&.is_seller && !@is_current_user # user can't leave review for themselves
    if !@profile.public_profile && !@is_current_user
      flash[:alert] = "This profile is private!"
      redirect_to root_path
    end
  end

  def destroy
    if Current.user.profile.blank?
      flash[:alert] = "You don't have a profile to delete!"
      redirect_to root_path and return
    elsif params[:id].to_i != Current.user.profile.id
      flash[:alert] = "You can only delete your own profile!"
      redirect_to root_path and return
    end
    Current.user.profile.destroy
    flash[:notice] = "Profile deleted successfully!"
    redirect_to root_path
  end

  def delete
    @profile = Current.user.profile
    if @profile.blank?
      flash[:alert] = "You don't have a profile to delete!"
      redirect_to root_path and return
    elsif params[:id].to_i != @profile.id
      flash[:alert] = "You can only delete your own profile!"
      redirect_to root_path and return
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :bio, :location, :twitter, :facebook, :instagram, :website, :occupation, :public_profile, :avatar)
  end
end
