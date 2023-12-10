require "rails_helper"

RSpec.describe Promotion, type: :model do
  let(:promo) { build(:promotion) }

  it { is_expected.to belong_to(:promotionable) }
  it { is_expected.to accept_nested_attributes_for(:promotionable) }
  it { is_expected.to have_and_belong_to_many(:products) }
  it { is_expected.to belong_to(:seller).class_name("User") }

  it { is_expected.to validate_length_of(:name).is_at_most(50).allow_blank }
  it { is_expected.to validate_presence_of(:starts_on) }
  it { is_expected.to validate_presence_of(:ends_on) }
  it { is_expected.to validate_numericality_of(:min_quantity).only_integer }
  it { is_expected.to validate_numericality_of(:max_quantity).only_integer }

  describe "#started?" do
    it "returns true when the promotion has started" do
      expect(promo.started?).to be_truthy
    end

    it "returns false when the promotion hasn't started" do
      expect(build(:promotion, :not_started).started?).to be_falsey
    end
  end

  describe "#ended?" do
    it "returns true when the promotion has ended" do
      expect(build(:promotion, :ended).ended?).to be_truthy
    end

    it "returns false when the promotion hasn't ended" do
      expect(promo.ended?).to be_falsey
    end
  end

  describe "#active?" do
    it "returns true when the promotion is active" do
      expect(promo.active?).to be_truthy
    end

    it "returns false when the promotion hasn't started" do
      expect(build(:promotion, :not_started).active?).to be_falsey
    end

    it "returns false when the promotion has ended" do
      expect(build(:promotion, :ended).active?).to be_falsey
    end
  end
end
