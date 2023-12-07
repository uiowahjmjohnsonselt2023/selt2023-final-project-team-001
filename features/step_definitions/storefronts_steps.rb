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
