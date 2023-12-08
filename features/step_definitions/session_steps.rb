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

Given("I am on the sign up page") do
  visit "/signup"
end

Then("I should be redirected to the homepage with a signup success message") do
  expect(page).to have_current_path("/")
  expect(page).to have_content("Sign up successful")
end

Given("I am on the login page") do
  visit "/login"
end

And("I enter valid credentials") do
  email = "test@email.com"
  password = "P4ssw0rd!"
  fill_in "email", with: email
  fill_in "password", with: password
end

When("I click the login button") do
  click_button "Login"
end

Then("I should be redirected to the homepage with a success message") do
  expect(page).to have_current_path("/")
  expect(page).to have_content("Successfully signed in!")
end

And("I enter invalid credentials") do
  fill_in "email", with: "not@real.com"
  fill_in "password", with: "b4dP4ssw0rd"
end

Then("I should see an error message") do
  expect(page).to have_content("Invalid email/password combination")
end

Given("I am logged in") do
  visit "/logout"
  steps %(
    Given I am on the login page
    And I enter valid credentials
    When I click the login button
    Then I should be redirected to the homepage with a success message
  )
end

Then("I should be redirected to the homepage with a signed-out message") do
  expect(page).to have_current_path("/")
  expect(page).to have_content("Signed out successfully!")
end

Then("I should be logged in") do
  expect(page).to have_content("Successfully signed in!")
end

When("I log out") do
  visit "/logout"
end

Then("I should be logged out") do
  expect(page).to have_content("Signed out successfully!")
end

And("I am not a seller") do
  email = "test@email.com"
  user = User.find_by(email: email)
  user.update_attribute(:is_seller, false)
end

When("I register as a seller") do
  visit "/register"
  check "I understand the above and wish to register"
  check "I have read and agree to the terms and conditions"
  click_button "Register"
end

Then("I should see a registration success message") do
  expect(page).to have_current_path("/")
  expect(page).to have_content("Registration successful")
end

Then("I should be prompted to log in") do
  expect(page).to have_content("You need to sign in before you can register as a seller!")
end

# Google forbids logging in through automated tests
# https://sqa.stackexchange.com/a/42348
# When("I log in through Google") do
#   visit '/login'
#   click_button 'Continue with Google'
#   click_button 'Use another account'
#   fill_in 'Email or phone', with: 'lab2emailsender@gmail.com'
#   fill_in 'Enter your password', with: 'lab2Password'
#   click_button 'Next'
# end

Then("I should be logged in through Google and see a success message") do
  expect(page).to have_content("Successfully signed in through Google!")
  expect(page).to have_current_path("/")
end

# Sad paths
And("I am a seller") do
  steps %(
    And I am not a seller
    When I register as a seller
  )
end

When("I try to register") do
  visit "/register"
end

Then("I should see a registration failure message") do
  expect(page).to have_content("You already are a seller, no need to register again!")
end

Then("I should see a logout failure message") do
  expect(page).to have_content("You need to sign in before you can sign out!")
end

Given("I am not logged in") do
  visit "/logout"
end

Then("I should see a not logged in registration failure message") do
  expect(page).to have_content("You need to sign in before you can register as a seller!")
end

And("I try to log in") do
  visit "/login"
end

Then("I should see an already logged in failure message") do
  expect(page).to have_content("You are already signed in!")
end
