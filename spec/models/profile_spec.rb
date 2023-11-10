require "rails_helper"

RSpec.describe Profile, type: :model do
  let(:valid_user) { create(:user, email: "testtests@admin.com", password: "admin1000", password_confirmation: "admin1000") }

  # full name is first_name plus last name
  it "has a full name" do
    profile = Profile.new(first_name: "John", last_name: "Doe")
    profile.user = valid_user
    expect(profile.full_name).to eq("John Doe")
  end
end
