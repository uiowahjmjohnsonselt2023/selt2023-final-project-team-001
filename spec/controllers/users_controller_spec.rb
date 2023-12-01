require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:valid_user) do
    {
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      password: "password123!P",
      password_confirmation: "password123!P"
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

  describe "GET #register" do
    context "when logged in as a non-seller" do
      it "renders the register page if a non-seller" do
        user = create(:user)
        login_as user
        get :register
        expect(response).to render_template("register")
      end
    end

    context "when logged in as a seller" do
      before do
        login_as create(:seller)
        get :register
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end

      it "tells the user they are already a seller if a seller" do
        expect(flash[:alert]).to eq("You already are a seller, no need to register again!")
      end
    end

    context "when not logged in" do
      before { get :register }

      it "redirects to the login page" do
        expect(response).to redirect_to(login_path)
      end

      it "tells the user to login before they register" do
        expect(flash[:alert]).to eq("You need to sign in before you can register as a seller!")
      end
    end
  end

  describe "POST #register" do
    context "with an unknown user" do
      before { post :new_seller }

      it "redirects the user to login" do
        expect(response).to redirect_to(login_path)
      end

      it "tells the user to login before they register" do
        expect(flash[:alert]).to eq("You need to sign in before you can register as a seller!")
      end
    end

    context "with a valid non-seller logged in" do
      it "retrieves a logged-in user's information from the database" do
        user = create(:user)
        login_as user
        post :new_seller
        expect(flash[:notice]).to eq("Registration successful")
      end
    end

    context "with a valid seller logged in" do
      before do
        login_as create(:seller)
        post :new_seller
      end

      it "redirects the user to the root path" do
        expect(response).to redirect_to(root_path)
      end

      it "tells the user they are already a seller if a seller" do
        expect(flash[:alert]).to eq("You already are a seller, no need to register again!")
      end
    end
  end
end
