class UsersController < ApplicationController

  before_action :require_login, only: [:register, :new_seller]
  before_action :require_not_seller, only: [:register, :new_seller]

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
      render "new", status: :unprocessable_entity
    end
  end

  def register
  end

  def new_seller
    Current.user.update_attribute(:is_seller, true)
    flash[:notice] = "Registration successful"
    redirect_to root_path
  end

  private

  # Redirects to the root path if the user is a seller.
  # An :alert flash is set before redirecting, using the translation for
  # the requested controller and action under the :require_not_seller scope.
  # See #i18n_t.
  def require_not_seller
    if Current.user.is_seller
      flash[:alert] = i18n_t scope: :require_not_seller
      redirect_to root_path
    end
  end
end
