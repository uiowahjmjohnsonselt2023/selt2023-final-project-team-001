require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "returns http success" do
      post login_path
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /destroy" do
    it "returns http redirect" do
      get logout_path
      expect(response).to have_http_status(:redirect)
    end
  end
end
