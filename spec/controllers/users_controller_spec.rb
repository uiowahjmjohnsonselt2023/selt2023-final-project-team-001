require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new user and redirects" do
        expect {
          post :create, params: {user: attributes_for(:user)}
        }.to change(User, :count).by(1)
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq("Sign up successful!")
      end
    end

    context "with invalid attributes" do
      it "does not creates a new user" do
        expect {
          post :create, params: {user: attributes_for(:user, password: "pass")}
        }.to_not change(User, :count)
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
      it "makes the user a seller" do
        user = login_as create(:user)
        expect { post :new_seller }.to change { user.reload.is_seller }.to(true)
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

  describe "GET #purchase_history" do
    context "when not logged in" do
      it "redirects the user to login" do
        get :purchase_history
        expect(flash[:alert]).to eq("You must log in to view your purchase history")
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before do
        login_as create(:user)
      end

      it "shows the user their purchase history" do
        get :purchase_history
        expect(response).to render_template :purchase_history
      end
    end
  end

  describe "GET #sales_history" do
    context "when not logged in as seller" do
      before do
        login_as create(:user)
      end

      it "directs the user to register as a seller" do
        get :sales_history
        expect(flash[:alert]).to eq("You must register as a seller to view sales history")
      end
    end

    context "when logged in as a seller" do
      before do
        login_as create(:seller)
      end

      it "shows a user their sales history" do
        get :sales_history
        expect(response).to render_template :sales_history
      end
    end
  end
end
