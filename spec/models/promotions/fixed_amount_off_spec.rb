require "rails_helper"
require_relative "../../concerns/promotionable_spec"

RSpec.describe Promotions::FixedAmountOff, type: :model do
  let(:product) { create(:product, price: 100) }
  let(:promo) { create(:fixed_amount_off, amount: 15, products: [product]) }

  it { is_expected.to monetize(:amount) }
  it_behaves_like "promotionable"

  describe "#discount" do
    let(:cart_item1) { create(:cart_item, product: product) }
    let(:cart_item2) { create(:cart_item, product: create(:product, price: 2000)) }
    let(:cart_items) { [cart_item1, cart_item2] }

    it "calls #below_max_quantity if max_quantity is greater than 0" do
      promo.update(max_quantity: 5)
      expect_any_instance_of(Promotions::FixedAmountOff)
        .to receive(:below_max_quantity)
        .and_return(cart_items)
      promo.discount(cart_items)
    end

    it "sets the applied_promotion for each cart item" do
      promo.discount(cart_items)
      expect(cart_item1.applied_promotion).to eq(promo.promotionable)
      expect(cart_item2.applied_promotion).to eq(promo.promotionable)
    end

    it "sets the discounted_subtotal for each cart item" do
      promo.discount(cart_items)
      expect(cart_item1.discounted_subtotal.cents).to eq(8500)
      expect(cart_item2.discounted_subtotal.cents).to eq(198500)
    end

    it "sets the discounted_subtotal to 0 if the amount is greater than the price" do
      promo.update(amount: 200)
      promo.discount(cart_items)
      expect(cart_item1.discounted_subtotal.cents).to eq(0)
      expect(cart_item2.discounted_subtotal.cents).to eq(180000)
    end
  end

  describe "#sample_discount" do
    it "returns the product price minus the amount" do
      expect(promo.sample_discount(product).cents).to eq(8500)
    end

    it "returns 0 if the amount is greater than the product price" do
      promo.update(amount: 200)
      expect(promo.sample_discount(product).cents).to eq(0)
    end
  end

  describe "#to_s" do
    it "returns a description of the promotion if it doesn't have a name" do
      expect(promo.to_s).to eq("$15.00 off select items")
    end
  end
end
