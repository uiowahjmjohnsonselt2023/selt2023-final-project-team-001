require "rails_helper"

describe CheckoutsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product, quantity: 10) }

  describe "index" do
    it "sets @products_in_cart when the cart is empty" do
      allow(controller).to receive(:require_login)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      allow(CartItem).to receive(:where).and_return([])
      get :index
      expect(assigns(:products_in_cart)).to eq([])
    end

    it "sets @products_in_cart when the cart is not empty" do
      allow(controller).to receive(:require_login)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      allow(CartItem).to receive(:where).and_return([CartItem.new(product_id: product.id, quantity: 1)])
      get :index
      expect(assigns(:products_in_cart)).to eq([{name: product.name, total_price: product.price, original_quantity: product.quantity, quantity: 1, id: product.id}])
    end
  end

  describe "update_quantity" do
    it "updates the quantity in the cart and redirects" do
      allow(controller).to receive(:require_login)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      cart = FactoryBot.create(:cart_item, user: user, product: product)
      post :update_quantity, params: {product_id: product.id, quantity: 2}
      expect(cart.reload.quantity).to eq(2)
      expect(flash[:success]).to eq("Item quantity updated successfully!")
      expect(response).to redirect_to(checkout_path)
    end
  end

  describe "#remove_from_cart" do
    it "removes the product from the cart and redirects (confirmation given)" do
      allow(controller).to receive(:require_login)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      FactoryBot.create(:cart_item, user: user, product: product)
      delete :remove_from_cart, params: {confirmation: "yes", product_id: product.id}
      expect(CartItem.find_by(user_id: user.id, product_id: product.id)).to be_nil
      expect(flash[:success]).to eq("Item removed from cart.")
      expect(response).to redirect_to(checkout_path)
    end
    it "removes the product from the cart and redirects (no confirmation given)" do
      allow(controller).to receive(:require_login)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      FactoryBot.create(:cart_item, user: user, product: product)
      delete :remove_from_cart, params: {confirmation: "no", product_id: product.id}
      expect(CartItem.find_by(user_id: user.id, product_id: product.id)).not_to be_nil
      expect(response).to redirect_to(checkout_path)
    end
  end

  describe "update_product_inventory" do
    it "places an order successfully and updates product inventory" do
      allow(controller).to receive(:require_login)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      cart = create(:cart_item, user: user, product: product)
      patch :update_product_inventory
      expect(flash[:notice]).to eq("Order placed successfully!")
      expect(response).to redirect_to(checkout_path)
      expect(CartItem.exists?(cart.id)).to be_falsey
      expect(Product.find(product.id).quantity).to eq(product.quantity - cart.quantity)
    end

    it "does not update inventory when cart is empty" do
      allow(controller).to receive(:require_login)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      post :update_product_inventory
      expect(flash[:alert]).to eq("You must add products to your cart to purchase them!")
      expect(response).to render_template(:index)
    end
  end
end
