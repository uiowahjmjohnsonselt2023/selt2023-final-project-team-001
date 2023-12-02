require "rails_helper"

RSpec.describe Storefront, type: :model do
  describe "validations" do
    it "requires a name" do
      storefront = build(:storefront, name: nil)
      expect(storefront).not_to be_valid
    end

    it "requires a short description" do
      storefront = build(:storefront, short_description: nil)
      expect(storefront).not_to be_valid
    end

    it "requires a user" do
      storefront = build(:storefront, user: nil)
      expect(storefront).not_to be_valid
    end

    it "requires a unique name" do
      storefront = create(:storefront)
      other_storefront = build(:storefront, name: storefront.name)
      expect(other_storefront).not_to be_valid
    end

    it "requires a name of 75 characters or less" do
      storefront = build(:storefront, name: "a" * 76)
      expect(storefront).not_to be_valid
    end

    it "requires a short description of 500 characters or less" do
      storefront = build(:storefront, short_description: "a" * 501)
      expect(storefront).not_to be_valid
    end
  end
end
