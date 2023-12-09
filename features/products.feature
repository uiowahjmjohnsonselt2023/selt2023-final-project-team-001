Feature: Products

  @needs_log_in
  Scenario: View all products
    Given I am logged in as a user
    And I register as a seller
    Given There are existing products
    When I visit the products page
    Then I should see a list of products

  @needs_log_in
  Scenario: View a product details
    Given I am logged in as a user
    And I register as a seller
    Given There are existing products
    When I visit the product details page
    Then I should see the product details

#  This test is impossible without js see line 66 of products_steps.rb
#  @needs_log_in
#  Scenario: Create a new product
#    Given I am logged in as a user
#    And I register as a seller
#    When I visit the new product page
#    Then I should see a form to create a new product
#    And I fill in the product details
#    And I submit the new product form
#    Then I should see the new product details
#
  @needs_log_in
  Scenario: Edit a product
    Given I am logged in as a user
    And I register as a seller
    Given There are existing products
    When I visit the product edit page
    And I update the product details
    And I submit the product edit form
    Then I should see the updated product details
#
#  Scenario: View product history
#    Given I am logged in
#    When I visit the product history page
#    Then I should see my viewed products
