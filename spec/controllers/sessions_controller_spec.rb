# spec/controllers/sessions_controller_spec.rb

require "rails_helper"

describe SessionsController, type: :controller do
  let(:valid_user) {
    create(:user,
      first_name: "test",
      last_name: "test",
      email: "admin@admin.com",
      password: "admin000",
      password_confirmation: "admin000")
  }

  describe "POST #create" do
    context "with valid credentials" do
      it "signs in the user goes to root" do
        expect(session[:user_id]).to be(nil)
        post :create, params: {email: valid_user.email, password: valid_user.password}
        expect(session[:user_id]).to be_truthy

        expect(response).to redirect_to("/")
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
      expect(response).to redirect_to("/")
    end

    it "displays a success flash message after logging in" do
      user = create(:user, email: "test3@test.com")
      session[:user_id] = user.id
      delete :destroy
      expect(flash[:notice]).to eq("Signed out successfully!")
    end

    it "redirects to the login when not logged in" do
      delete :destroy
      expect(response).to redirect_to("/login")
    end

    it "gives flash message telling to log in when not logged in" do
      delete :destroy
      expect(flash[:notice]).to eq("You need to sign in before you can sign out!")
    end
  end

  describe "GET #new" do
    it "renders the sign-in page" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET #register" do
    it "renders the register page" do
      get :register
      expect(response).to render_template("register")
    end
  end

  describe "POST #register" do
    context "with an unknown user" do
      it "redirects the user to login" do
        session[:user_id] = nil
        post :new_seller
        expect(response).to redirect_to("/login")
      end

      it "tells the user to login before they register" do
        session[:user_id] = nil
        post :new_seller
        expect(flash[:notice]).to eq("You need to sign in before you can register as a seller!")
      end
    end

    context "with a valid user logged in" do
      it "retrieves a logged-in user's information from the database" do
        user = create(:user)
        session[:user_id] = user.id
        post :new_seller, params: {storefront: "Fake flower shop", email: valid_user.email}
        expect(flash[:notice]).to eq("Registration successful")
      end
    end
  end
end
