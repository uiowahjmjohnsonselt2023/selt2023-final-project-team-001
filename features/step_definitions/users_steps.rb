Before("@delete_user?") do
  visit "/logout"
  email = "test@email.com"
  user = User.find_by(email: email)

  user&.destroy
end

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

Given("I am on the signup page") do
  visit "/signup"
end

When("I fill in with valid information") do
  email = "test@email.com"
  password = "P4ssw0rd!"
  fill_in "First Name", with: "John"
  fill_in "Last Name", with: "Doe"
  fill_in "Email", with: email
  fill_in "Password", with: password
  fill_in "Confirm Password", with: password
  click_button "Signup"
end

Then("I should see a signup success message") do
  expect(page).to have_content("Sign up successful!")
end

When("I click on the login link") do
  click_link "login-link"
end

Then("I should be on the login page") do
  expect(page).to have_current_path("/login")
end

Given("I validly log in") do
  # handled by @needs_log_in
end

# And("I have no profile") do
#   user = User.find_by(email: 'valid@email.com')
#   user&.profile&.destroy
# end

# Failing to find the dropdown rn
# When("I go to my profile page") do
#   user = User.find_by(email: 'valid@email.com')
#   click_on("#{user.full_name}")
#   click_button 'Profile'
# end

# Then("I should be redirected to the profile creation page") do
#   expect(page).to have_current_path('/profile/new')
# end

And("I have a profile") do
  user = User.find_by(email: "valid@email.com")
  # make profile
  user.create_profile
end

When("I go to my profile page") do
  user = User.find_by(email: "valid@email.com")
  visit "/profiles/#{user.profile.id}"
end

Then("I should see my profile") do
  expect(page).to have_content("Profile")
end

# Sad paths
When("I fill in with invalid information") do
  fill_in "First Name", with: "John"
  fill_in "Last Name", with: "Doe"
  fill_in "Email", with: "valid@email.com"
  fill_in "Password", with: "P4ssw0rd!"
  fill_in "Confirm Password", with: "P4ssw0rd!"
  click_button "Signup"
end

Then("I should see a signup failure message") do
  expect(page).to have_content("Email\nhas already been taken")
end

When("I fill in with no information") do
  click_button "Signup"
end

Then("I should see a field saying to fill it in") do
  expect(page).to have_content("can't be blank")
end

When("I fill in with mismatched passwords") do
  fill_in "First Name", with: "John"
  fill_in "Last Name", with: "Doe"
  fill_in "Email", with: "sample@email.com"
  fill_in "Password", with: "P4ssw0rd!"
  fill_in "Confirm Password", with: "P4ssw0rd!!!!!"
  click_button "Signup"
end

Then("I should see a password mismatch message") do
  expect(page).to have_content("doesn't match Password")
end

When("I go to the profile creation page") do
  visit "/profiles/new"
end

Then("I should be redirected to the login page") do
  expect(page).to have_current_path("/login")
  expect(page).to have_content("You need to login before you can create a profile!")
end
