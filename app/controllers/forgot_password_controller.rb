class ForgotPasswordController < ApplicationController
  def new
    @email = params[:email] if params[:send_link]
    @confirm_email = params[:confirm_email] if params[:send_link]
  end

  def check_for_email
    @email = params[:email]
    @confirm_email = params[:confirm_email]

    if @email != @confirm_email
      flash[:alert] = "Emails do not match!"
      render :new
    else
      all_emails = User.pluck(:email)
      unless all_emails.include?(params[:confirm_email])
        @option_to_signup = true
        flash[:alert] = "There is no account associated with that email."
        redirect_to forgot_password_path
      end
    end
  end

  def send_link
    check_for_email
  end
end
