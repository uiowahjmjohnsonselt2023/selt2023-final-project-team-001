Feature: Adding Products to Cart

  @needs_log_in
  Scenario: Adding a product to the cart
    Given I am logged in as a user
    And The following products exist:
      | name           | quantity | price |
      | Laptop         | 50        | 1000  |
    And "Laptop" is in my cart with a quantity of "1"
    When I update the quantity of "Laptop" to "10"
    When I add "3" "Laptop" to my cart
    Then I should see 13 Laptops in my cart