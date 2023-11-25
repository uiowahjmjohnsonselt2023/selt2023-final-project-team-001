class ForgotPasswordController < ApplicationController
  def new
    @email = params[:email]
    @confirm_email = params[:confirm_email]
  end

  def send_link
    @email = params[:email]
    @confirm_email = params[:confirm_email]

    if @email != @confirm_email
      flash[:alert] = "Emails do not match!"
      render :new
    else
      flash[:success] = "If an account with that email was found we have sent a link to reset your password!"
      redirect_to login_path
    end
  end
end
