require "rails_helper"

describe CheckoutsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  describe "index" do
    it "sets @products_in_cart when the cart is empty" do
      allow(controller).to receive(:set_current_user)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      allow(Cart).to receive(:where).and_return([])
      get :index
      expect(assigns(:products_in_cart)).to eq([])
    end

    it "sets @products_in_cart when the cart is not empty" do
      allow(controller).to receive(:set_current_user)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      allow(Cart).to receive(:where).and_return([Cart.new(product_id: product.id, quantity: 1)])
      get :index
      expect(assigns(:products_in_cart)).to eq([{name: product.name, price: product.price_cents, quantity: 1, id: product.id}])
    end
  end

  describe "update_quantity" do
    it "updates the quantity in the cart and redirects" do
      allow(controller).to receive(:set_current_user)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      cart = FactoryBot.create(:cart, user: user, product: product)
      post :update_quantity, params: {product_id: product.id, quantity: 2}
      expect(cart.reload.quantity).to eq(2)
      expect(response).to redirect_to(checkout_path)
    end
  end

  describe "#remove_from_cart" do
    it "removes the product from the cart and redirects" do
      allow(controller).to receive(:set_current_user)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      FactoryBot.create(:cart, user: user, product: product)
      delete :remove_from_cart, params: {product_id: product.id}
      expect(Cart.find_by(user_id: user.id, product_id: product.id)).to be_nil
      expect(response).to redirect_to(checkout_path)
    end
  end
end
