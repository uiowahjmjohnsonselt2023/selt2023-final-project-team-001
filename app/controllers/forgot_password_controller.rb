class ForgotPasswordController < ApplicationController
  def new
  end

  def send_link
    @email = params[:email]
    @confirm_email = params[:confirm_email]

    if @email != @confirm_email
      flash[:alert] = "Emails do not match!"
      render :new
    else
      all_emails = User.pluck(:email)
      if !all_emails.include?(params[:confirm_email])
        flash[:success] = "Password reset instructions have been sent to your email!"
        redirect_to login_path
      else
        @option_to_signup = true
        flash[:alert] = "There is no account associated with that email."
        redirect_to forgot_password_path
      end
    end
  end
end
