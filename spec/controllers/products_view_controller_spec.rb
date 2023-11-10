# spec/controllers/products_view_controller_spec.rb

require "rails_helper"

describe ProductsViewController, type: :controller do
  let(:valid_user) { create(:user, email: "admin@admin.com", password: "admin") }

  describe "GET #products" do
    it "displays all products" do
      expect(response).to render_template("display")
    end
  end
end
