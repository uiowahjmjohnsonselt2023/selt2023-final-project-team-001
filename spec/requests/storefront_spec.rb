require "rails_helper"

RSpec.describe "Storefronts", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/storefront/show"
      expect(response).to have_http_status(:success)
    end
  end
end
