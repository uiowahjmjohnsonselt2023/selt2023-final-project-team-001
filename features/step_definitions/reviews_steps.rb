Before("@needs_log_in") do
  visit "/logout"
  email = "test@email.com"
  password = "P4ssw0rd!"
  user = User.find_by(email: email)

  user&.destroy

  @new_user = User.create(
    first_name: "John",
    last_name: "Doe",
    email: email,
    password: password,
    password_confirmation: password,
    is_seller: false,
    is_admin: false
  )
  @new_user.update_attribute(:is_seller, false)
  @new_user.update_attribute(:is_admin, false)
end

Before("@needs_user") do
  visit "/logout"
  email = "test@email.com"
  password = "P4ssw0rd!"
  user = User.find_by(email: email)

  user&.destroy

  @new_user = User.create(
    first_name: "John",
    last_name: "Doe",
    email: email,
    password: password,
    password_confirmation: password,
    is_seller: false,
    is_admin: false
  )
  @new_user.update_attribute(:is_seller, false)
  @new_user.update_attribute(:is_admin, false)
  @new_profile = FactoryBot.create(:profile, user: @new_user)
  @new_user.save
end

And("There is a seller with a public profile") do
  @seller = FactoryBot.create(:seller)
  @profile = FactoryBot.create(:profile, user: @seller)
  @profile.update_attribute(:public_profile, true)
  @seller.save
end

When("I go to the new review page for that seller") do
  visit "/review?profile_id=#{@seller.profile.id}"
end

Then("I should see a form to leave a review") do
  expect(page).to have_current_path("/review?profile_id=#{@seller.profile.id}")
  expect(page).to have_content("Create a Review")
  expect(page).to have_content("Describe your experience")
end

When("I fill in the review form with valid information") do
  expect(page).to have_content("Create a Review")
  expect(page).to have_content("Rate your interaction and/or purchase:")
  expect(page).to have_content("(Optional) Describe your experience:")
  choose "5 - Excellent"
end

And("I submit the review") do
  click_button "Submit Review"
end

Then("I should see a success message") do
  expect(page).to have_content("Review successfully created!")
end

And("The seller's profile should show the updated seller rating") do
  expect(page).to have_content("5")
end

When("I am on the new review page for my own profile") do
  visit "/review?profile_id=#{@new_user.profile.id}"
end

Then("I should get redirected and see an alert that I cannot leave a review for myself") do
  expect(page).to have_content("You cannot leave a review for yourself.")
  expect(page).to have_current_path("/profiles/#{@new_user.profile.id}")
end

Given("There is a public profile for a non seller") do
  @seller = FactoryBot.create(:seller)
  @profile = FactoryBot.create(:profile, user: @seller)
  @profile.update_attribute(:public_profile, true)
  @seller.update_attribute(:is_seller, false)
  @seller.save
end

When("I go to the new review page for that user") do
  visit "/review?profile_id=#{@seller.profile.id}"
end

Then("I should see an alert that I cannot leave a review for a non-seller") do
  expect(page).to have_content("You cannot leave a review for someone who is not a seller.")
end
