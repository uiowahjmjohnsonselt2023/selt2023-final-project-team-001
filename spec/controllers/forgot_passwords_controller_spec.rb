require "rails_helper"

describe ForgotPasswordController, type: :controller do
  describe "new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "send_link" do
    context "when the emails match" do
      let(:user) { create(:user) }

      it "sends a password reset email and redirects" do
        allow(PasswordMailer).to receive_message_chain(:with, :reset, :deliver_now)
        post :send_link, params: {email: user.email, confirm_email: user.email}
        expect(response).to redirect_to(login_path)
        expect(PasswordMailer).to have_received(:with).with(user: user)
        expect(flash[:success]).to eq("If an account with that email was found we have sent a link to reset your password!")
      end
    end

    context "when emails do not match" do
      it "sets flash alert and renders new template" do
        post :send_link, params: {email: "test@test.com", confirm_email: "test1@test.com"}
        expect(response).to render_template :new
        expect(flash[:alert]).to eq("Emails do not match!")
      end
    end
  end

  describe "edit" do
    context "with a valid token" do
      let(:user) { create(:user) }
      let(:token) { user.signed_id(purpose: "password_reset") }

      it "renders the edit template" do
        get :edit, params: {token: token}
        expect(response).to render_template :edit
      end
    end

    context "with an invalid token" do
      it "sets flash alert and redirects to forgot password path" do
        get :edit, params: {token: "invalid_token"}
        expect(response).to redirect_to(forgot_password_path)
        expect(flash[:alert]).to eq("Your password reset token has expired, please try again.")
      end
    end
  end

  describe "update" do
    let(:user) { create(:user) }
    let(:token) { user.signed_id(purpose: "password_reset") }

    context "with valid password parameters" do
      it "resets the password and redirects to login path" do
        patch :update, params: {token: token, user: {password: "new_password", password_confirmation: "new_password"}}
        expect(response).to redirect_to(login_path)
        expect(flash[:success]).to eq("Your password was reset successfully!")
      end
    end

    context "with invalid password parameters" do
      it "sets flash alert and renders edit template" do
        patch :update, params: {token: token, user: {password: "bleep", password_confirmation: "bloop"}}
        expect(response).to render_template :edit
        expect(flash[:alert]).to eq("Invalid input(s)!")
      end
    end
  end
end
