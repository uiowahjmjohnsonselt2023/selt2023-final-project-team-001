# spec/controllers/sessions_controller_spec.rb

require "rails_helper"

describe SessionsController, type: :controller do
  let(:valid_user) {
    create(:user,
      first_name: "test",
      last_name: "test",
      email: "admin@admin.com",
      password: "admin000!P",
      password_confirmation: "admin000!P")
  }

  describe "POST #create" do
    context "with valid credentials" do
      it "signs in the user goes to root" do
        expect(session[:user_id]).to be(nil)
        post :create, params: {email: valid_user.email, password: valid_user.password}
        expect(session[:user_id]).to be_truthy

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Successfully signed in!")
      end
    end

    context "with invalid credentials" do
      it "does not sign in the user" do
        expect(session[:user_id]).to be(nil)
        post :create, params: {email: "bad_email@email.com", password: "bad_password"}
        expect(session[:user_id]).to be(nil)

        expect(response).to render_template("new")

        expect(flash[:alert]).to eq("Invalid email/password combination")
      end
    end
  end

  describe "DELETE #destroy" do
    it "signs out the user" do
      user = create(:user, email: "test1@test.com")
      session[:user_id] = user.id
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root after logging in" do
      user = create(:user, email: "test2@test.com")
      session[:user_id] = user.id
      delete :destroy
      expect(response).to redirect_to(root_path)
    end

    it "displays a success flash message after logging in" do
      user = create(:user, email: "test3@test.com")
      session[:user_id] = user.id
      delete :destroy
      expect(flash[:notice]).to eq("Signed out successfully!")
    end

    it "redirects to the login when not logged in" do
      delete :destroy
      expect(response).to redirect_to(login_path)
    end

    it "gives flash message telling to log in when not logged in" do
      delete :destroy
      expect(flash[:alert]).to eq("You need to sign in before you can sign out!")
    end
  end

  describe "GET #new" do
    it "renders the sign-in page" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET #omniauth" do
    let(:provider) { "google_oauth2" }
    let(:uid) { "123456789" }
    let(:email) { "omni@auth.com" }
    let(:first_name) { "John" }
    let(:last_name) { "Doe" }

    before do
      request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
        provider: provider,
        uid: uid,
        info: {
          email: email,
          first_name: first_name,
          last_name: last_name
        }
      )
    end

    it "creates a new user with valid omniauth data" do
      expect do
        get :omniauth, params: {provider: provider}
      end.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(session[:user_id]).to be_present
      expect(flash[:success]).to eq("Successfully signed in through Google!")
    end

    it "redirects to login_path if the user already exists" do
      User.create!(uid: nil, provider: nil, email: email, first_name: first_name, last_name: last_name, password: "password!P", password_confirmation: "password!P")

      get :omniauth, params: {provider: provider}

      expect(response).to redirect_to(login_path)
      expect(flash[:alert]).to include("already have an account with us")
    end
  end
end
