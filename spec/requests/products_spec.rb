require "rails_helper"

RSpec.describe "Products", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/products/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/products/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/products/edit"
      expect(response).to have_http_status(:success)
    end
  end
end
