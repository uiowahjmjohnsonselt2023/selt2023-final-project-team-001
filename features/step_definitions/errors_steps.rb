Given("A user requests a non-existing page") do
  visit "/non-existing-page"
end

Then("The user encounters a 404 error") do
  expect(page).to have_content "404"
end

Given('They should see the "Not Found" page') do
  expect(page).to have_content "Page not Found"
  expect(page).to have_content "Sorry, the page you were looking for could not be found."
  expect(page).to have_content "Go back"
end
