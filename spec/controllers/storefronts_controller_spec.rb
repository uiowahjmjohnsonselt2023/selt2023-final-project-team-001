require "rails_helper"

RSpec.describe StorefrontsController, type: :controller do
  let(:user) { FactoryBot.create(:user, :seller) }

  before do
    session[:user_id] = user.id
  end

  describe "GET #new" do
    context "when user is logged in and is a seller" do
      it "renders the new template" do
        puts(user.is_seller)
        get :new
        expect(response).to render_template(:new)
      end

      it "assigns necessary variables" do
        get :new
        expect(assigns(:products)).to eq(user.products)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        get :new
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "Get #new_storefront_with_template" do
    context "when user is logged in and is a seller" do
      it "renders the new_storefront_with_template template" do
        get :new_storefront_with_template
        expect(response).to render_template(:new_storefront_with_template)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        get :new_storefront_with_template
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST #create" do
    context "when user is logged in and is a seller" do
      context "when user clicks the 'Preview Custom Code' button" do
        it "renders the new template" do
          post :create, params: {storefront: {custom_code: "1"}, preview_button: "Preview Custom Code"}
          expect(response).to render_template(:new)
        end

        it "assigns necessary variables" do
          post :create, params: {storefront: {custom_code: "1"}, preview_button: "Preview Custom Code"}
          expect(assigns(:products)).to eq(user.products)
        end
      end

      context "when user clicks the 'Save' button" do
        it "redirects to the storefront" do
          post :create, params: {storefront: {custom_code: "1"}, save_button: "Save"}
          expect(response).to redirect_to(storefront_path(user.storefront))
        end

        it "updates the storefront with the custom code" do
          post :create, params: {storefront: {custom_code: "1"}, save_button: "Save"}
          expect(user.storefront.reload.custom_code).to eq("1")
        end
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        post :create, params: {storefront: {custom_code: "1"}, save_button: "Save"}
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST #choose_template" do
    context "when user is logged in and is a seller" do
      it "redirects to the storefront" do
        post :choose_template, params: {template_number: "1"}
        expect(response).to redirect_to(storefront_path(user.storefront))
      end

      it "updates the storefront with the custom code" do
        post :choose_template, params: {template_number: "1"}
        expect(user.storefront.reload.custom_code).to eq("1")
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        post :choose_template, params: {template_number: "1"}
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
