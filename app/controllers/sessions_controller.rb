class SessionsController < ApplicationController
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
    if session[:user_id].nil?
      flash[:notice] = "You need to sign in before you can register as a seller!"
      redirect_to "/login" and return
    end
    user = User.find_by(id: session[:user_id])
    if user.update_attribute(:is_seller, true)
      flash[:notice] = "Registration successful"
      redirect_to "/"
    end
  end
end
