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
end
