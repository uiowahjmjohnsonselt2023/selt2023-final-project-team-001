class SessionsController < ApplicationController
  # mentioned in lecture but I'm not sure how it applies yet
  # skip_before_filter :require_login
  def new
    # automatically renders the sign-in form
    if session[:user_id].present?
      flash[:alert] = "You are already signed in!"
      redirect_to root_path
    end
  end

  def create
    # Handle sign-in and authentication logic
    email = params[:email]
    password = params[:password]
    user = User.find_by(email: email)

    if user
      if user&.authenticate(password)
        session[:user_id] = user.id
        flash[:notice] = "Successfully signed in!"
        redirect_to root_path and return
      end
    end
    flash[:alert] = "Invalid email/password combination"
    render "new"
  end

  def destroy
    # Handle sign-out logic
    if session[:user_id].nil?
      flash[:notice] = "You need to sign in before you can sign out!"
      redirect_to login_path and return
    end
    session[:user_id] = nil
    flash[:notice] = "Signed out successfully!"
    redirect_to root_path
  end

  def register
  end

  def new_seller
    if session[:user_id].nil?
      flash[:notice] = "You need to sign in before you can register as a seller!"
      redirect_to "/login" and return
    end
    user = User.find_by(id: session[:user_id])
    user.is_seller = :t
    user.save
    flash[:notice] = "Registration successful"
  end
end
