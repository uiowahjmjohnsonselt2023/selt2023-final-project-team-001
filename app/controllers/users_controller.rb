class UsersController < ApplicationController
  before_action :require_login, only: [:show, :index]
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def index
  end

  def show
    @user = Current.user
    unless Current.user?(params[:id])
      flash[:warning] = "Can only show profile of logged-in user"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Sign up successful!"
      redirect_to login_path
    else
      flash[:alert] = "Invalid input(s)!"
      render "new"
    end
  end
end
