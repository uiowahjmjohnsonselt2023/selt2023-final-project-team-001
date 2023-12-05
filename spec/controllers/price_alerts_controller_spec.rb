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

    context "when price alert exists" do
      it "redirects to the price alert show page" do
        product = FactoryBot.create(:product)
        price_alert = FactoryBot.create(:price_alert, product: product, user: user)
        get :new, params: {product_id: product.id}
        expect(response).to redirect_to price_alert_path(price_alert.id)
        expect(flash[:alert]).to eq I18n.t("price_alerts.new.already_exists")
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
