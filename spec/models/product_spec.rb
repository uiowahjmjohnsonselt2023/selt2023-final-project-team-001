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

    it "requires a price greater than 0" do
      product = build(:product, price: [nil, -1].sample)
      expect(product).not_to be_valid
    end

    it "requires a quantity greater than 0" do
      product = build(:product, quantity: [nil, -1].sample)
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
