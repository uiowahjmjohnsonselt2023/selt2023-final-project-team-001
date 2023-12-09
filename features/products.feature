Feature: Products

  Scenario: View all products
    Given There are existing products
    When I visit the products page
    Then I should see a list of products

#  Scenario: View a product details
#    Given There are existing products
#    When I visit the product details page
#    Then I should see the product details
#
#  Scenario: Create a new product
#    Given I am logged in as a seller
#    When I visit the new product page
#    And I fill in the product details
#    And I submit the new product form
#    Then I should see the new product details
#
#  Scenario: Edit a product
#    Given there is an existing product
#    And I am logged in as the product's seller
#    When I visit the product edit page
#    And I update the product details
#    And I submit the product edit form
#    Then I should see the updated product details
#
#  Scenario: View product history
#    Given I am logged in
#    When I visit the product history page
#    Then I should see my viewed products
