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

Given("I am on the forgot password page") do
  visit "/forgot_password"
end

# I don't actually wanna send emails without mocking...
# When("I fill in my email and confirm email") do
#   fill_in "Email", with: @new_user.email
#   fill_in "Confirm Email", with: @new_user.email
# end

And("I submit the form") do
  click_button "Send Link"
end

Then("I should see a form to enter my email and confirm email") do
  expect(page).to have_content("Forgot Password")
  expect(page).to have_content("Email")
  expect(page).to have_content("Confirm Email")
  expect(page).to have_content("Provide us with the email associated with your account, and we will send you a reset link.")
end

When("I fill in my email and confirm email with different emails") do
  fill_in "Email", with: @new_user.email, match: :prefer_exact
  fill_in "Confirm Email", with: "jeff@example.com"
end

Then('I should see an alert "Emails do not match!"') do
  expect(page).to have_content("Emails do not match!")
end

And("I should stay on the forgot password page") do
  expect(page).to have_content("Forgot Password")
  expect(page).to have_content("Email")
  expect(page).to have_content("Confirm Email")
  expect(page).to have_content("Provide us with the email associated with your account, and we will send you a reset link.")
end
