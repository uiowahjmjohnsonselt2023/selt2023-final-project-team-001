require "rails_helper"

RSpec.describe Review, type: :model do
  describe "validations" do
    it "requires a description" do
      review = build(:review, description: nil)
      expect(review).not_to be_valid
    end

    it "requires a rating" do
      review = build(:review, interaction_rating: nil)
      expect(review).not_to be_valid
    end
  end
end
