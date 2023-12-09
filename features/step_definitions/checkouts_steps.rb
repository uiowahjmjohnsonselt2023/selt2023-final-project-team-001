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

When("I visit the checkout page") do
  visit checkout_path
end

Then("I should see a message indicating that my cart is empty") do
  expect(page).to have_content "Your cart is empty!"
end
