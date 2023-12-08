require "rails_helper"

RSpec.describe Profile, type: :model do
  let(:user) { create(:user) }
  let(:seller) { create(:seller) }

  # full name is first_name plus last name
  it "has a full name" do
    profile = Profile.new(first_name: "John", last_name: "Doe")
    profile.user = user
    expect(profile.full_name).to eq("John Doe")
  end

  # describe "validations" do
  #   # This test doesn't work because the set_public_if_seller method is called
  #   # before validation, so the public_profile attribute is always true. We shouldn't
  #   # even need the validation, but I added it just in case. However, I'm not sure how
  #   # I could even test it.
  #   # it "must be public for sellers" do
  #   #   profile = Profile.new(public_profile: false)
  #   #   profile.user = seller
  #   #   expect(profile).to_not be_valid
  #   # end
  # end

  describe "set_public_if_seller" do
    it "sets public_profile to true if user is a seller" do
      profile = seller.create_profile
      profile.update(public_profile: false)
      expect(profile.public_profile).to eq(true)
    end

    it "isn't called when public_profile is set to true" do
      profile = Profile.new
      profile.user = seller
      expect(profile).to_not receive(:set_public_if_seller)
      profile.update(public_profile: true)
    end

    it "isn't called when public_profile isn't changed" do
      profile = seller.create_profile
      expect(profile).to_not receive(:set_public_if_seller)
      profile.update(first_name: "John")
    end
  end
end
