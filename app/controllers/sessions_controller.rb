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
        redirect_to "/"
      end
    else
      flash[:alert] = "Invalid email/password combination"
      render "new"
    end
  end

  def destroy
    # Handle sign-out logic
    session[:user_id] = nil
    flash[:notice] = "Signed out successfully!"
    redirect_to "/"
  end
end
