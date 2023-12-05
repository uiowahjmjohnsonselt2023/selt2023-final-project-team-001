require "rails_helper"

RSpec.describe PriceAlertsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    session[:user_id] = user.id
  end

  describe "GET #new" do
    context "when price alert does not exists" do
      it "renders the new template" do
        product = FactoryBot.create(:product)
        get :new, params: {product_id: product.id}
        expect(response).to render_template :new
      end
    end
  end

  # describe "POST #create" do
  #
  # end
  #
  # describe "GET #show" do
  #
  # end
end
