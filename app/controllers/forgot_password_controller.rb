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
      @user = User.find_by(email: @email)
      if @user.present?
        PasswordMailer.with(user: @user).reset.deliver_now
      end
      flash[:success] = "If an account with that email was found we have sent a link to reset your password!"
      redirect_to login_path
    end
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: "password_reset")
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    flash[:alert] = "Your password reset token has expired, please try again."
    redirect_to forgot_password_path
  end

  def update
    @user = User.find_signed!(params[:token], purpose: "password_reset")
    if @user.update(password_params)
      flash[:success] = "Your password was reset successfully!"
      redirect_to login_path
    else
      flash[:alert] = "Invalid input(s)!"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
