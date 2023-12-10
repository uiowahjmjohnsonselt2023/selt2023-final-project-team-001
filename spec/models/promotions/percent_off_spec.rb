require "rails_helper"
require_relative "../../concerns/promotionable_spec"

RSpec.describe Promotions::PercentOff, type: :model do
  let(:product) { create(:product, price: 100) }
  let(:promo) { create(:percent_off, percentage: 0.5, products: [product]) }

  it_behaves_like "promotionable"

  describe "#discount" do
    let(:cart_item1) { create(:cart_item, product: product) }
    let(:cart_item2) { create(:cart_item, product: create(:product, price: 2000)) }
    let(:cart_items) { [cart_item1, cart_item2] }

    it "calls #below_max_quantity if max_quantity is greater than 0" do
      promo.update(max_quantity: 5)
      expect_any_instance_of(Promotions::PercentOff)
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
      expect(cart_item1.discounted_subtotal.cents).to eq(5000)
      expect(cart_item2.discounted_subtotal.cents).to eq(100000)
    end
  end

  describe "#sample_discount" do
    it "returns the product price times the percentage" do
      expect(promo.sample_discount(product).cents).to eq(5000)
    end
  end

  describe "#to_s" do
    it "returns a description of the promotion if it doesn't have a name" do
      expect(promo.to_s).to eq("50.0% off select items")
    end
  end

  describe "#decimalize_percentage" do
    it "divides the percentage by 100" do
      promo.percentage = 50
      expect {
        promo.valid?
      }.to change(promo, :percentage).from(50).to(0.5)
    end
  end
end
