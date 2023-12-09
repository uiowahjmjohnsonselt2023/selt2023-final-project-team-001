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

When("I add {string} {string} to my cart") do |quantity, product_name|
  visit "/products/#{Product.find_by(name: product_name).id}"
  fill_in "quantity", with: 3
  click_on "Add to Cart", match: :first
end

Then("I should see 13 Laptops in my cart") do
  expect(page).to have_content("13")
end
