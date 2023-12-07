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
      it "redirects to the price alert index page" do
        product = FactoryBot.create(:product)
        FactoryBot.create(:price_alert, product: product, user: user)
        get :new, params: {product_id: product.id}
        expect(response).to redirect_to price_alerts_path
        expect(flash[:alert]).to eq I18n.t("price_alerts.new.already_exists")
      end
    end
  end

  describe "POST #create" do
    context "when price alert does not exists" do
      it "creates a new price alert" do
        product = FactoryBot.create(:product)
        post :create, params: {product_id: product.id, new_threshold: 100}
        expect(response).to redirect_to price_alerts_path
        expect(flash[:notice]).to eq I18n.t("price_alerts.create.success")
      end
    end

    context "when price alert exists" do
      it "redirects to the price alert show page" do
        product = FactoryBot.create(:product)
        FactoryBot.create(:price_alert, product: product, user: user)
        post :create, params: {product_id: product.id, new_threshold: 100}
        expect(response).not_to redirect_to price_alert_path(PriceAlert.last.id)
        expect(flash[:alert]).to eq I18n.t("price_alerts.create.failure")
      end
    end
  end

  describe "GET #edit" do
    context "when the price alert belongs to the user" do
      it "renders the edit template" do
        price_alert = FactoryBot.create(:price_alert, user: user)
        get :edit, params: {id: price_alert.id}
        expect(response).to render_template :edit
      end
    end

    context "when the price alert does not belong to the user" do
      it "redirects to the home page" do
        price_alert = FactoryBot.create(:price_alert)
        get :edit, params: {id: price_alert.id}
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq I18n.t("price_alerts.edit.not_yours")
      end
    end
  end

  describe "PATCH #update" do
    context "when the price alert belongs to the user" do
      it "updates the price alert" do
        price_alert = FactoryBot.create(:price_alert, user: user)
        patch :update, params: {id: price_alert.id, price_alert: {new_threshold: 100}}
        expect(response).to redirect_to price_alerts_path
        expect(flash[:notice]).to eq I18n.t("price_alerts.update.success")
      end
    end

    context "when the price alert does not belong to the user" do
      it "redirects to the home page" do
        price_alert = FactoryBot.create(:price_alert)
        patch :update, params: {id: price_alert.id, price_alert: {new_threshold: 100}}
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq I18n.t("price_alerts.update.not_yours")
      end
    end

    context "when the price alert does not update" do
      it "redirects to root with proper flash" do
        price_alert = FactoryBot.create(:price_alert, user: user)
        patch :update, params: {id: price_alert.id, price_alert: {new_threshold: -1}}
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq I18n.t("price_alerts.update.failure")
      end
    end
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "DELETE #destroy" do
    context "when the price alert belongs to the user" do
      it "deletes the price alert" do
        price_alert = FactoryBot.create(:price_alert, user: user)
        delete :destroy, params: {id: price_alert.id}
        expect(response).to redirect_to price_alerts_path
        expect(flash[:notice]).to eq I18n.t("price_alerts.destroy.success")
      end
    end

    context "when the price alert does not belong to the user" do
      it "redirects to the home page" do
        price_alert = FactoryBot.create(:price_alert)
        delete :destroy, params: {id: price_alert.id}
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq I18n.t("price_alerts.destroy.not_yours")
      end
    end
  end

  describe "DELETE #delete" do
    context "when the price alert belongs to the user" do
      it "renders the delete template" do
        price_alert = FactoryBot.create(:price_alert, user: user)
        delete :delete, params: {id: price_alert.id}
        expect(response).to render_template :delete
      end
    end

    context "when the price alert does not belong to the user" do
      it "redirects to the home page" do
        price_alert = FactoryBot.create(:price_alert)
        delete :delete, params: {id: price_alert.id}
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq I18n.t("price_alerts.delete.not_yours")
      end
    end
  end
end
