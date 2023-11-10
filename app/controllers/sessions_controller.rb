class SessionsController < ApplicationController
  # mentioned in lecture but I'm not sure how it applies yet
  # skip_before_filter :set_current_user
  def new
    # automatically renders the sign-in form
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
        redirect_to "/" and return
      end
    end
    flash[:alert] = "Invalid email/password combination"
    render "new"
  end

  def destroy
    # Handle sign-out logic
    if session[:user_id].nil?
      flash[:notice] = "You need to sign in before you can sign out!"
      redirect_to "/login" and return
    end
    session[:user_id] = nil
    flash[:notice] = "Signed out successfully!"
    redirect_to "/"
  end
end

def register
  if session[:user_id].nil?
    flash[:notice] = "You need to sign in before you can register as a seller!"
    redirect_to "/login"
  end
end
