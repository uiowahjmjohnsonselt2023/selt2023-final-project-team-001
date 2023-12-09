Given("There are existing products") do
  @products = FactoryBot.create_list(:product, 5)
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
