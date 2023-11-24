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
        # Add more variable assignment checks as needed
      end

      # Add more tests for various scenarios (e.g., preview_button present or absent)
    end

    context "when user is not logged in" do
      it "redirects to login" do
        session[:user_id] = nil
        get :new
        expect(response).to redirect_to(login_path)
      end
    end
  end

  # More tests for other actions like create, choose_template, show, etc.
end
