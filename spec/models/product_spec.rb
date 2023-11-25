require "rails_helper"

RSpec.describe Product, type: :model do
  describe "validations" do
    it "requires a name" do
      product = build(:product, name: nil)
      expect(product).not_to be_valid
    end

    it "requires a description" do
      product = build(:product, description: nil)
      expect(product).not_to be_valid
    end

    it "requires a price" do
      product = build(:product, price: nil)
      expect(product).not_to be_valid
    end

    it "requires a quantity" do
      product = build(:product, quantity: nil)
      expect(product).not_to be_valid
    end

    it "requires a condition" do
      product = build(:product, condition: nil)
      expect(product).not_to be_valid
    end

    it "requires a seller" do
      product = build(:product, seller: nil)
      expect(product).not_to be_valid
    end

    it "requires a valid condition" do
      product = build(:product, condition: "invalid")
      expect(product).not_to be_valid
    end

    it "requires a non-nil price" do
      product = build(:product, price: nil)
      expect(product).not_to be_valid
    end

    it "requires a non-negative price" do
      product = build(:product, price: -1)
      expect(product).not_to be_valid
    end

    it "requires a non-zero price" do
      product = build(:product, price: 0)
      expect(product).not_to be_valid
    end

    it "requires a non-nil quantity" do
      product = build(:product, quantity: nil)
      expect(product).not_to be_valid
    end

    it "requires a non-negative quantity" do
      product = build(:product, quantity: -1)
      expect(product).not_to be_valid
    end
  end

  it "can store multiple categories" do
    product = create(:product)
    # add 2 categories to the product
    categories = Category.all.sample(2)
    product.categories << categories
    product.save
    result = Product.last.categories
    expect(result).to eq(categories)
  end
end
