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
