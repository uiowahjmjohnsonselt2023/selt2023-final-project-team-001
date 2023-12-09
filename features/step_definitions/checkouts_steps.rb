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
    is_seller: true,
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

#  Scenario: Adding items to the cart
#     And the following products exist:
#       | name           | Quantity | Price |
#       | Laptop         | 5        | 1000  |
#       | Smartphone     | 8        | 800   |
#       | Headphones     | 10       | 200   |
And("The following products exist:") do |table|
  table.hashes.each do |product|
    new_prod = FactoryBot.create(:product, name: product[:name], quantity: product[:quantity], price: product[:price])
    @new_user.products << new_prod
    @new_user.save
  end
end

When("I add {string} and {string} to my cart") do |product_name, product_name2|
  prod1 = Product.find_by(name: product_name)
  prod2 = Product.find_by(name: product_name2)
  visit product_path(prod1)
  click_button "Add to Cart"
  visit product_path(prod2)
  click_button "Add to Cart"
end

Then("I should see them in my cart") do
  visit checkout_path
  expect(page).to have_content "Laptop"
  expect(page).to have_content "Smartphone"
end

And("The cart total should reflect the correct sum of prices") do
  expect(page).to have_content "$1,800.00"
end

And("{string} is in my cart with a quantity of {string}") do |product_name, quantity|
  prod = Product.find_by(name: product_name)
  visit product_path(prod)
  click_button "Add to Cart"
  visit checkout_path
  select quantity, from: "quantity"
  # click_on "quantity"
  click_button "Update"
end

When("I update the quantity of {string} to {string}") do |product_name, quantity|
  visit checkout_path
  select quantity, from: "quantity"
  # click_on "quantity"
  click_button "Update"
end

Then("I should see a success message indicating the quantity update") do
  expect(page).to have_content "Item quantity updated successfully!"
end

And("The updated quantity and total price should reflect in my cart") do
  expect(page).to have_content "$2,000.00"
  expect(page).to have_content "2"
end
