Before("@no_storefronts") do
  Storefront.destroy_all
end

Before("@needs_storefronts") do
  user = User.create(
    first_name: "John",
    last_name: "Doe",
    email: "email1@email.com",
    password: "P4ssw0rd!",
    password_confirmation: "P4ssw0rd!",
    is_seller: true,
    is_admin: false
  )
  user.profile = Profile.create

  user.storefront = Storefront.create(
    custom_code: "1",
    name: "John Doe's Storefront",
    short_description: "We've got stuff",
    user_id: user.id
  )
  user.save

  user2 = User.create(
    first_name: "Jim",
    last_name: "Smith",
    email: "email2@email.com",
    password: "P4ssw0rd!",
    password_confirmation: "P4ssw0rd!",
    is_seller: true,
    is_admin: false
  )

  user2.profile = Profile.create

  user2.storefront = Storefront.create(
    custom_code: "1",
    name: "Jim Smith's Storefront",
    short_description: "We've got better stuff",
    user_id: user2.id
  )
  user2.save
end

When("I go to the storefronts page") do
  visit "/storefronts"
end

Then("I should see a no storefront message") do
  expect(page).to have_content("There are no storefronts to display.")
end

Then("I should see a list of storefronts") do
  expect(page).to have_content("John Doe's Storefront")
  expect(page).to have_content("Jim Smith's Storefront")
end

When("I visit the new storefront page") do
  visit "/storefronts/new"
end

Then("I should see a form to create a new storefront") do
  expect(page).to have_content("New Storefront")
  expect(page).to have_content("Name")
  expect(page).to have_content("Short description")
end

And("I fill in the storefront form") do
  fill_in "Name", with: "Le Epic Storefront"
  fill_in "Short description", with: "We've got stuff"
  click_button "Create Storefront"
end

Then("I should be redirected to the storefront page") do
  expect(page).to have_content("Le Epic Storefront")
  expect(page).to have_content("We've got stuff")
  expect(page).to have_content("Storefront successfully created!")
  expect(page).to have_content("You haven't set the look of your storefront yet. To update the look of your storefront, choose a template. (If you're feeling adventurous, you can also write your own HTML.) Until you do so, other users will see this:")
end

And("I am on the customize storefront page") do
  user = User.find_by(email: "test@email.com")
  visit "/storefronts/#{user.storefront.id}/customize"
end

And("I create a storefront") do
  steps %(
    Given I am logged in
    And I register as a seller
    When I visit the new storefront page
    And I fill in the storefront form
  )
end

And("I enter custom code in the preview section") do
  fill_in "storefront_custom_code", with: "<h1>Custom Code Example</h1>"
end

And("I click on the 'Preview' button") do
  click_button "Preview Custom Code"
end

And("I click on the 'Save' button") do
  click_button "Save Custom Code"
end

Then("I should see a preview of the storefront with the custom code") do
  expect(page).to have_content("Custom Code Example")
end

And("I am on the choose template page") do
  user = User.find_by(email: "test@email.com")
  visit "/storefronts/#{user.storefront.id}/choose_template"
end

Then("I should be redirected to the storefront page with custom code") do
  user = User.find_by(email: "test@email.com")
  expect(page).to have_content("Storefront successfully updated!")
  expect(page).to have_content("Custom Code Example")
  expect(page).to have_current_path("/storefronts/#{user.storefront.id}")
end

And("I click choose this for my storefront") do
  click_button "Choose this for my storefront"
end

Then("I should be redirected to the storefront page with the template") do
  user = User.find_by(email: "test@email.com")
  expect(page).to have_content("Storefront successfully updated!")
  expect(page).to have_content("Le Epic Storefront")
  expect(page).to have_content("We've got stuff")
  expect(page).to have_current_path("/storefronts/#{user.storefront.id}")
end
