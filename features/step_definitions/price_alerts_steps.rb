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
  @new_user.update_attribute(:is_seller, true)
  @new_user.profile = Profile.create
  @new_user.update_attribute(:is_admin, false)
  @new_user.products = []
  @new_user.save

  visit "/logout"
  email = "user@email.com"
  password = "P4ssw0rd!"
  user = User.find_by(email: email)

  user&.destroy

  @new_user2 = User.create(
    first_name: "Johns",
    last_name: "Does",
    email: email,
    password: password,
    password_confirmation: password,
    is_seller: false,
    is_admin: false
  )
  @new_user2.update_attribute(:is_seller, false)
  @new_user2.update_attribute(:is_admin, false)
  @new_user2.save
end

Given("I am logged in as a different user") do
  email = "user@email.com"
  password = "P4ssw0rd!"
  # handled by @needs_log_in
  visit "/login"
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Login"
end

When("I visit the new price alert page for {string}") do |string|
  visit "/price_alerts/new?product_id=#{Product.find_by(name: string).id}"
end

And("I set a price threshold of {string}") do |thresh|
  expect(page).to have_content("New Price Alert")
  fill_in "New threshold", with: thresh
end

And("I submit the price alert form") do
  click_button "Create Price Alert"
end

Then("I should see a success message {string}") do |string|
  expect(page).to have_content(string)
end

And("I should be redirected to the price alerts page") do
  expect(page).to have_current_path(price_alerts_path)
end

Then('I should see an alert "You cannot add your own product to your price alerts!"') do
  expect(page).to have_content("You cannot add your own product to your price alerts!")
end

And("I should be redirected to the homepage") do
  expect(page).to have_current_path(root_path)
end
