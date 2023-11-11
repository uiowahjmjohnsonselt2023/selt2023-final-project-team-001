# spec/controllers/products_view_controller_spec.rb

require "rails_helper"

describe ProductsController, type: :controller do
  let(:valid_user) { create(:user, email: "admin@admin.com", password: "admin") }

  describe "GET #products" do
    it "displays all products" do
      get :display
      expect(response).to render_template("display")
    end
  end
end
