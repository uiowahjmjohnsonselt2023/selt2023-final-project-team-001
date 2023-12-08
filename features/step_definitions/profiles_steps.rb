Before("@needs_log_in") do
  visit "/logout"
  email = "valid@email.com"
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

Given("I am logged in as a user") do
  email = "valid@email.com"
  password = "P4ssw0rd!"
  # handled by @needs_log_in
  visit "/login"
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Login"
end

When("I go to edit my profile page") do
  email = "valid@email.com"
  user = User.find_by(email: email)
  visit "/profiles/#{user.profile.id}/edit"
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
