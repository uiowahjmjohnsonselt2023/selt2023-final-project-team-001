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

Given("I am logged in as a user") do
  email = "test@email.com"
  password = "P4ssw0rd!"
  # handled by @needs_log_in
  visit "/login"
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Login"
end

When("I go to edit my profile page") do
  visit "/profiles/#{@new_user.profile.id}/edit"
end

Then("I should see the profile edit form") do
  expect(page).to have_content("Edit Profile")
  expect(page).to have_content("First Name")
  expect(page).to have_content("Last Name")
  expect(page).to have_content("Bio")
  expect(page).to have_content("Profile Picture")
  expect(page).to have_content("Location")
  expect(page).to have_content("Twitter")
  expect(page).to have_content("Facebook")
  expect(page).to have_content("Instagram")
  expect(page).to have_content("Website")
  expect(page).to have_content("Occupation")
  expect(page).to have_content("Profile Visibility")
end

When("I update my profile information") do
  fill_in "First Name", with: "Jimmy"
  fill_in "Last Name", with: "Lee"
  fill_in "Bio", with: "I'm a person"
  fill_in "Location", with: "USA"
  click_button "Update Profile"
end

Then("My profile should be updated with the new information") do
  expect(page).to have_content("Profile was successfully updated.")
  expect(page).to have_content("Jimmy")
  expect(page).to have_content("Lee")
  expect(page).to have_content("I'm a person")
  expect(page).to have_content("USA")
end

And("I do not have a profile") do
  if @new_user.profile.present?
    @new_user.profile.destroy
  end
end

When("I go to create a new profile") do
  visit "/profiles/new"
end

Then("I should see a profile creation form") do
  expect(page).to have_content("New Profile")
  expect(page).to have_content("First Name")
  expect(page).to have_content("Last Name")
  expect(page).to have_content("Bio")
  expect(page).to have_content("Profile Picture")
  expect(page).to have_content("Location")
  expect(page).to have_content("Twitter")
  expect(page).to have_content("Facebook")
  expect(page).to have_content("Instagram")
  expect(page).to have_content("Website")
  expect(page).to have_content("Occupation")
  expect(page).to have_content("Profile Visibility")
end

And("I have a profile") do
  # make profile
  @new_user.create_profile
end

When("I fill in the profile creation form with valid information") do
  fill_in "First Name", with: "Jimmy"
  fill_in "Last Name", with: "Lee"
  fill_in "Bio", with: "I'm a person"
end

And("I submit the profile creation form") do
  click_button "Create Profile"
end

Then("I should see a profile creation success message") do
  expect(page).to have_content("Profile created successfully!")
end

And("My profile should be created with the entered information") do
  expect(page).to have_content("Jimmy")
  expect(page).to have_content("Lee")
  expect(page).to have_content("I'm a person")
end

Then("I should see an alert that I already have a profile") do
  expect(page).to have_content("You already have a profile!")
  expect(page).to have_current_path("/profiles/#{@new_user.profile.id}")
end

Given("There is a public profile") do
  @seller = FactoryBot.create(:seller)
  @profile = FactoryBot.create(:profile, user: @seller)
  @profile.update_attribute(:public_profile, true)
  @seller.save
end

When("I view the profile") do
  visit "/profiles/#{@seller.profile.id}"
end

Then("I should see the profile details") do
  expect(page).to have_content(@seller.profile.first_name)
  expect(page).to have_content(@seller.profile.last_name)
  expect(page).to have_content(@seller.profile.bio)
  expect(page).to have_current_path "/profiles/#{@seller.profile.id}"
end

Given("There is a private profile") do
  @seller = FactoryBot.create(:seller)
  @profile = FactoryBot.create(:profile, user: @seller)
  @profile.update_attribute(:public_profile, false)
  @seller.save
end

Then("I should see an alert that the profile is private") do
  expect(page).to have_content("This profile is private!")
  expect(page).to have_current_path("/")
end
