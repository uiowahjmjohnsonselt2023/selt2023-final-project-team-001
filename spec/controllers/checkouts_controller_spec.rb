require "rails_helper"

describe CheckoutsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product, price: 123, quantity: 10) }
  let(:cart) { create(:cart, user: user) }
  let(:cart_item) { create(:cart_item, cart: cart, product: product) }

  before { login_as user }

  describe "index" do
    it "calls Cart#apply_promotions" do
      expect_any_instance_of(Cart).to receive(:apply_promotions).and_call_original
      get :index
    end
  end

  describe "update_quantity" do
    it "updates the quantity in the cart and redirects" do
      expect {
        post :update_quantity, params: {cart_item_id: cart_item.id, quantity: 2}
      }.to change { cart_item.reload.quantity }.by(1)
    end

    it "redirects with a notice" do
      post :update_quantity, params: {cart_item_id: cart_item.id, quantity: 2}
      expect(flash[:success]).to eq("Item quantity updated successfully!")
      expect(response).to redirect_to(checkout_path)
    end
  end

  describe "#remove_from_cart" do
    it "removes the product from the cart (confirmation given)" do
      delete :remove_from_cart, params: {confirmation: "yes", cart_item_id: cart_item.id}
      expect(CartItem.exists?(cart_item.id)).to be_falsey
    end

    it "redirects with a success flash (confirmation given)" do
      delete :remove_from_cart, params: {confirmation: "yes", cart_item_id: cart_item.id}
      expect(flash[:success]).to eq("Item removed from cart.")
      expect(response).to redirect_to(checkout_path)
    end

    it "removes the product from the cart (no confirmation given)" do
      delete :remove_from_cart, params: {confirmation: "no", cart_item_id: cart_item.id}
      expect(CartItem.exists?(cart_item.id)).to be_truthy
    end

    it "redirects (no confirmation given)" do
      delete :remove_from_cart, params: {confirmation: "no", cart_item_id: cart_item.id}
      expect(response).to redirect_to(checkout_path)
    end
  end

  describe "update_product_inventory" do
    it "deletes cart items and updates product inventory" do
      cart_item # Need to create the cart item before the post request
      patch :update_product_inventory
      expect(CartItem.exists?(cart_item.id)).to be_falsey
      expect(product.reload.quantity).to eq(9)
    end

    it "redirects with a notice" do
      cart_item
      patch :update_product_inventory
      expect(flash[:notice]).to eq("Order placed successfully!")
      expect(response).to redirect_to(checkout_path)
    end

    it "does not update inventory when cart is empty" do
      patch :update_product_inventory
      expect(flash[:alert]).to eq("You must add products to your cart to purchase them!")
      expect(response).to render_template(:index)
    end

    it "creates a new transaction" do
      allow(controller).to receive(:require_login)
      allow(controller).to receive(:session).and_return(user_id: user.id)
      cart = create(:cart, user: user, product: product)
      expect {
        patch :update_product_inventory
      }.to change(Transaction, :count).by(1)
      expect(Cart.exists?(cart.id)).to be_falsey
    end
  end
end
