require "rails_helper"

RSpec.describe "PriceAlerts", type: :request do
  describe "GET /send_price_alert" do
    it "returns http success" do
      get "/send_price_alert"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /send_test_email" do
    it "returns http success" do
      get "/send_test_email"
      expect(response).to have_http_status(:success)
    end
  end
end
