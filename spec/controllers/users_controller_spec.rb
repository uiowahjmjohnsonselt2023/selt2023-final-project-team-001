require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:valid_user) do
    {
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
  end

  let(:invalid_user) do
    {
      first_name: "John",
      last_name: "Doe",
      email: "john.doeexample.com",
      password: "pass",
      password_confirmation: "password123"
    }
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new user and redirects" do
        expect {
          post :create, params: {user: valid_user}
        }.to change(User, :count).by(1)
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq("Sign up successful!")
      end
    end

    context "with invalid attributes" do
      it "does not creates a new user" do
        expect {
          post :create, params: {user: invalid_user}
        }.to change(User, :count).by(0)
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq("Invalid input(s)!")
      end
    end
  end
end
