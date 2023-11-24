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
end
