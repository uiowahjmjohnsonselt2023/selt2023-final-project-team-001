require "rails_helper"

shared_examples_for "promotionable" do
  let(:model) { described_class }
  let(:model_name) { model.to_s.demodulize.underscore.to_sym }
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user: user) }
  let(:cart_item) { create(:cart_item, cart: cart) }

  def build_model(...)
    build(model_name, ...)
  end

  def create_model(...)
    create(model_name, ...)
  end

  it { is_expected.to have_one(:promotion) }

  describe "#eligible?" do
    it "returns false when the promotion hasn't started" do
      promo = create_model(:not_started, seller: cart_item.seller)
      expect(promo.eligible?(cart_item)).to be_falsey
    end

    it "returns false when the promotion has ended" do
      promo = create_model(:ended, seller: cart_item.seller)
      expect(promo.eligible?(cart_item)).to be_falsey
    end

    # it "returns false when a promotion has already been applied" do
    # end

    it "returns false when the promotion is from a different seller" do
      promo = create_model(seller: create(:seller))
      expect(promo.eligible?(cart_item)).to be_falsey
    end

    it "returns false when the product is not included in the promotion" do
      promo = create_model
      expect(promo.eligible?(cart_item)).to be_falsey
    end

    it "returns true when the promotion is for all of the seller's products" do
      promo = create_model(products: [], seller: cart_item.seller)
      expect(promo.eligible?(cart_item)).to be_truthy
    end

    it "returns true when the product is included in the promotion" do
      promo = create_model(products: [cart_item.product])
      expect(promo.eligible?(cart_item)).to be_truthy
    end
  end

  describe "#below_max_quantity" do
    let(:promo) { create_model(max_quantity: 5) }
    let(:cart_items) do
      [
        create(:cart_item, quantity: 3, product: create(:product, quantity: 3)),
        create(:cart_item, quantity: 1, product: create(:product, quantity: 1)),
        create(:cart_item, quantity: 2, product: create(:product, quantity: 2)),
        create(:cart_item, quantity: 1, product: create(:product, quantity: 1))
      ]
    end

    it "passes over cart items that would put it over the max quantity" do
      expect(promo.below_max_quantity(cart_items))
        .to contain_exactly(*cart_items[0..1], cart_items[3])
    end

    it "returns all cart items if the max quantity is 0" do
      promo.update(max_quantity: 0)
      expect(promo.below_max_quantity(cart_items)).to eq(cart_items)
    end

    it "returns all items if their total quantity is less than the max quantity" do
      promo.update(max_quantity: 10)
      expect(promo.below_max_quantity(cart_items)).to eq(cart_items)
    end
  end

  describe "#product_eligible?" do
    it "returns true when the product is included in the promotion" do
      promo = create_model(products: [cart_item.product])
      expect(promo.product_eligible?(cart_item)).to be_truthy
    end

    it "returns true when the promotion is for all of the seller's products" do
      promo = create_model(products: [], seller: cart_item.seller)
      expect(promo.product_eligible?(cart_item)).to be_truthy
    end

    it "returns false when the product is not included in the promotion" do
      promo = create_model
      expect(promo.product_eligible?(cart_item)).to be_falsey
    end
  end

  describe "#to_s" do
    it "returns the name if it has one" do
      promo = create_model(name: "Test Promotion")
      expect(promo.to_s).to eq("Test Promotion")
    end
  end
end
