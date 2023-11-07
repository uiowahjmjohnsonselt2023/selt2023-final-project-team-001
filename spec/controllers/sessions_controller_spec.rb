# spec/controllers/sessions_controller_spec.rb

require "rails_helper"

describe SessionsController, type: :controller do
  describe "POST #create" do
    context "with valid credentials" do
      it "signs in the user" do
        user = create(:user) # Create a test user
        post :create, params: {session: {email: user.email, password: user.password}}
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(user_profile_path(user))
      end
    end

    context "with invalid credentials" do
      it "does not sign in the user" do
        user = create(:user)
        post :create, params: {session: {email: user.email, password: "wrong_password"}}
        expect(session[:user_id]).to be_nil
        expect(response).to render_template("new")
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    it "signs out the user" do
      user = create(:user)
      session[:user_id] = user.id
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root path" do
      delete :destroy
      expect(response).to redirect_to("/")
    end

    it "displays a success flash message" do
      delete :destroy
      expect(flash[:notice]).to be_present
    end
  end

  # Other tests can be added
end
