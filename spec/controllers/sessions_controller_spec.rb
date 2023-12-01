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
end
