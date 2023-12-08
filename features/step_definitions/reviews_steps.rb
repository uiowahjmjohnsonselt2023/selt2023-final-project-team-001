Before("@needs_user") do
  visit "/logout"
  email = "test@email.com"
  password = "P4ssw0rd!"
  user = User.find_by(email: email)

  user&.destroy

  new_user = User.create(
    first_name: "John",
    last_name: "Doe",
    email: email,
    password: password,
    password_confirmation: password,
    is_seller: false,
    is_admin: false
  )
  new_user.update_attribute(:is_seller, false)
  new_user.update_attribute(:is_admin, false)
end

And("There is a seller with a public profile") do
  @seller = FactoryBot.create(:seller)
  @profile = FactoryBot.create(:profile, user: @seller)
  @profile.update_attribute(:public_profile, true)
  @seller.save
  puts(@seller.profile.id)
end

When("I go to the new review page for that seller") do
  visit "/profiles/#{@seller.profile.id}"
end

Then("I should see a form to leave a review") do
  expect(page).to have_current_path("/profiles/#{@profile.id}")
  expect(page).to have_content("Name")
  expect(page).to have_content("Bio")
  expect(page).to have_content("Location")
  expect(page).to have_content("Twitter")
  expect(page).to have_content("Facebook")
  expect(page).to have_content("Instagram")
  expect(page).to have_content("Website")
  expect(page).to have_content("Occupation")
  expect(page).to have_content("Seller Rating (out of 5)")
  expect(page).to have_content("Leave A Review")
end

When("I fill in the review form with valid information") do
  expect(page).to have_content("Leave A Review")
  choose "Yes"
  click_on "5 - Excellent"
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
