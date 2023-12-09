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

Given("There are existing products") do
  @products = FactoryBot.create_list(:product, 5)
  @products.each do |product|
    @new_user.products << product
    @new_user.save
  end
end

When("I visit the products page") do
  visit products_path
end

Then("I should see a list of products") do
  @products.each do |product|
    expect(page).to have_content product.name
  end
end

When("I visit the product details page") do
  visit product_path(@products.first)
end

Then("I should see the product details") do
  expect(page).to have_content @products.first.name
  expect(page).to have_content @products.first.description
  expect(page).to have_content @products.first.price
  expect(page).to have_content @products.first.quantity
end

When("I visit the new product page") do
  visit new_product_path
end

Then("I should see a form to create a new product") do
  expect(page).to have_content "Name"
  expect(page).to have_content "Description"
  expect(page).to have_content "Price"
  expect(page).to have_content "Quantity"
  expect(page).to have_content "Condition"
  expect(page).to have_content "Categories"
  expect(page).to have_content "Photos"
end

And("I fill in the product details") do
  fill_in "Name", with: "Test Product"
  fill_in "Description", with: "This is a test product."
  fill_in "Price", with: 10
  fill_in "Quantity", with: 1
  # this is how I would do it, but because it is populated by js, capybara says no options exist yet it is required
  # select('Motors', from: 'product[category_ids][]', visible: false)
  # this is a hacky fix
  # page.execute_script("document.querySelector('#product_category_ids').innerHTML += '<option value=\"1\">Motors</option>'")
  # select('Motors', from: 'product[category_ids][]')
  # that didn't work because rack_test doesn't support js and execute script
  select("Motors", from: "product_category_ids")
  # that also didn't work because rack_test doesn't support js, selenium-webdriver made random tests fail that shouldn't and poltergeist isn't supported anymore
  # I deem this untestable for now but trust me it works
end

And("I submit the new product form") do
  click_button "Create Product"
end

Then("I should see the new product details") do
  expect(page).to have_content "Test Product"
  expect(page).to have_content "This is a test product."
  expect(page).to have_content 10
  expect(page).to have_content 1
  expect(page).to have_content "Motors"
end

When("I visit the product edit page") do
  visit edit_product_path(@products.first)
end

And("I update the product details") do
  fill_in "Name", with: "Test Product"
  fill_in "Description", with: "This is a test product."
  fill_in "Price", with: 10
  fill_in "Quantity", with: 1
end

And("I submit the product edit form") do
  click_button "Update Product"
end

Then("I should see the updated product details") do
  expect(page).to have_content "Test Product"
  expect(page).to have_content "This is a test product."
  expect(page).to have_content 10
  expect(page).to have_content 1
end
