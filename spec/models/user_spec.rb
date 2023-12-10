require "rails_helper"

RSpec.describe User, type: :model do
  describe "Validations" do
    describe "first_name" do
      it "should not validate presence" do
        user = build(:user, first_name: nil)
        expect(user).to_not be_valid
      end
      it "should not validate length" do
        user = build(:user, first_name: "x" * 100)
        expect(user).to_not be_valid
      end
    end

    describe "last_name" do
      it "should not validate presence" do
        user = build(:user, last_name: nil)
        expect(user).to_not be_valid
      end
      it "should not validate length" do
        user = build(:user, last_name: "x" * 100)
        expect(user).to_not be_valid
      end
    end

    describe "email" do
      it "should not validate presence" do
        user = build(:user, email: nil)
        expect(user).to_not be_valid
      end
      it "should not validate uniqueness of email (case-insensitive)" do
        create(:user, email: "abc@abc.com")
        user = build(:user, email: "ABC@abc.com")
        expect(user).to_not be_valid
      end
      it "should not validate format" do
        user = build(:user, email: "test")
        expect(user).to_not be_valid
      end
    end

    describe "password" do
      it "should not validate presence" do
        user = build(:user, password: nil)
        expect(user).to_not be_valid
      end
      it "should not validate length" do
        user = build(:user, password: "x")
        expect(user).to_not be_valid
      end
    end

    describe "password_confirmation" do
      it "should not validate presence" do
        user = build(:user, password_confirmation: nil)
        expect(user).to_not be_valid
      end
      it "should not validate length" do
        user = build(:user, password_confirmation: "x")
        expect(user).to_not be_valid
      end
    end
  end

  describe "full_name" do
    it "should properly format full name" do
      user = build(:user, first_name: "John", last_name: "Doe")
      expect(user.full_name).to eq("John Doe")
    end
  end

  describe "is_admin=" do
    it "sets is_seller when is_admin is set to true" do
      user = build(:user)
      expect { user.is_admin = true }.to change { user.is_seller }.from(false).to(true)
    end

    it "sets is_buyer when is_admin is set to true" do
      user = build(:user)
      expect { user.is_admin = true }.to change { user.is_buyer }.from(false).to(true)
    end
  end

  describe "update_profile_visibility" do
    it "creates a public profile if user is a seller without a profile" do
      user = build(:user)
      expect {
        # Have to use `update` here since we need to commit for the callback to run
        user.update(is_seller: true)
      }.to change { user.profile }.from(nil)
      expect(user.profile.public_profile).to eq(true)
    end

    it "sets public_profile to true if user is a seller with a profile" do
      user = create(:user_with_private_profile)
      expect {
        user.update(is_seller: true)
      }.to change { user.profile.public_profile }.from(false).to(true)
    end

    it "isn't called if user is not a seller" do
      user = build(:user)
      expect(user).to_not receive(:update_profile_visibility)
      user.save
    end

    it "isn't called if is_seller is set to false" do
      user = create(:user)
      expect(user).to_not receive(:update_profile_visibility)
      user.update(is_seller: false)
    end
  end
end
