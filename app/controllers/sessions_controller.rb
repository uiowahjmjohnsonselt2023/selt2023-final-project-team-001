class SessionsController < ApplicationController
  # mentioned in lecture but I'm not sure how it applies yet
  # skip_before_filter :require_login
  def new
    # automatically renders the sign-in form
    @email = params[:email]
    if session[:user_id].present?
      flash[:alert] = "You are already signed in!"
      redirect_to root_path
    end
  end

  def create
    # Handle sign-in and authentication logic
    @email = params[:email]
    password = params[:password]
    user = User.find_by(email: @email)

    if user&.authenticate(password)
      session[:user_id] = user.id
      redirect_to root_path, notice: "Successfully signed in!"
    else
      flash[:alert] = "Invalid email/password combination"
      render "new", status: :unauthorized
    end
  end

  def destroy
    # Handle sign-out logic
    if session[:user_id].nil?
      flash[:alert] = "You need to sign in before you can sign out!"
      redirect_to login_path and return
    end
    session[:user_id] = nil
    flash[:notice] = "Signed out successfully!"
    redirect_to root_path
  end

  def register
  end

  def new_seller
    unless Current.user
      flash[:notice] = "You need to sign in before you can register as a seller!"
      redirect_to "/login" and return
    end
    if Current.user.update_attribute(:is_seller, true)
      flash[:notice] = "Registration successful"
      redirect_to root_path
    else
      flash[:notice] = "Registration could not be completed"
    end
  end

  def omniauth
    info = request.env["omniauth.auth"]
    user = User.find_by(uid: info[:uid], provider: info[:provider])
    if user
      session[:user_id] = user.id
      flash[:success] = "Successfully signed in through Google!"
      redirect_to root_path
    else
      user = User.new(
        uid: info[:uid],
        provider: info[:provider],
        first_name: info[:info][:first_name],
        last_name: info[:info][:last_name],
        email: info[:info][:email]
      )
      p = SecureRandom.hex(15) + "!P"
      user.password = p
      user.password_confirmation = p

      if user.save
        session[:user_id] = user.id
        flash[:success] = "Successfully signed in through Google!"
        redirect_to root_path
      else
        flash[:alert] = "You may already have an account with us, log in with your email and password."
        redirect_to login_path
      end
    end
  end
end
