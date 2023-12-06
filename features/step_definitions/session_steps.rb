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

When("I enter valid credentials") do
  email = "test@email.com"
  password = "P4ssw0rd!"
  # @user = User.find_by(email: email)
  # unless @user
  #   visit '/signup'
  #   fill_in 'First Name', with: 'John'
  #   fill_in 'Last Name', with: 'Doe'
  #   fill_in 'Email', with: email
  #   fill_in 'Password', with: password
  #   fill_in 'Confirm Password', with: password
  #   click_button 'Signup'
  # end
  fill_in "email", with: email
  fill_in "password", with: password
  click_button "Login"
end

Then("I should be redirected to the homepage with a success message") do
  expect(page).to have_current_path("/")
  expect(page).to have_content("Successfully signed in!")
end

When("I enter invalid credentials") do
  fill_in "email", with: "not@real.com"
  fill_in "password", with: "b4dP4ssw0rd"
  click_button "Login"
end

Then("I should see an error message") do
  expect(page).to have_content("Invalid email/password combination")
end

Given("I am logged in") do
  steps %(
    Given I am on the login page
    When I enter valid credentials
    Then I should be redirected to the homepage with a success message
  )
  email = "test@email.com"
  user = User.find_by(email: email)
  puts(user.is_seller)
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

Given("I am not a seller") do
  email = "test@email.com"
  user = User.find_by(email: email)
  user.update_attribute(:is_seller, false)
  puts(user.is_seller)
end

When("I register as a seller") do
  sleep(10) # Pause for 2 seconds
  visit "/register"
  sleep(2) # Pause for 2 seconds
  fill_in "Storefront name:", with: "Sample Storefront"
  sleep(2) # Pause for 2 seconds
  check "I agree to the terms and conditions"
  sleep(2) # Pause for 2 seconds
  click_button "Submit"
  sleep(2) # Pause for 2 seconds
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
