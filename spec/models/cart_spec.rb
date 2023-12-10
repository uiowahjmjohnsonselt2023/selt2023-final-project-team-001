require "rails_helper"

RSpec.describe Cart, type: :model do
  let(:cart_item2) do
    create(:cart_item, cart: cart, product: create(:product, price: 7))
  end
  let(:cart_item1) do
    create(:cart_item, cart: cart, product: create(:product, price: 182))
  end
  let(:cart) { create(:cart) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:cart_items).dependent(:destroy) }
  it { is_expected.to have_many(:products).through(:cart_items) }
  it { is_expected.to have_many(:promotions).through(:cart_items) }

  it { is_expected.to delegate_method(:empty?).to(:cart_items) }
  it { is_expected.to delegate_method(:size).to(:cart_items) }
  it { is_expected.to delegate_method(:length).to(:cart_items) }

  describe "#subtotal" do
    it "returns the sum of the cart items' subtotals" do
      cart_item1
      cart_item2
      expect(cart.subtotal).to eq(Money.new(18900))
    end
  end

  describe "#apply_promotions" do
    it "returns cart_items if the cart is empty" do
      expect(cart.apply_promotions).to eq(cart.cart_items)
    end
  end
end
