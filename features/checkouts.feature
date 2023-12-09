Feature: Shopping Cart Checkout

  Background:
    Given I am logged in as a user

  @needs_log_in
  Scenario: Viewing an empty cart
    When I visit the checkout page
    Then I should see a message indicating that my cart is empty

  @needs_log_in
  Scenario: Adding items to the cart
    And I register as a seller
    And The following products exist:
      | name           | quantity | price |
      | Laptop         | 5        | 1000  |
      | Smartphone     | 8        | 800   |
      | Headphones     | 10       | 200   |
    When I add "Laptop" and "Smartphone" to my cart
    Then I should see them in my cart
    And The cart total should reflect the correct sum of prices
#
#  Scenario: Updating cart item quantity
#    Given "Laptop" is in my cart with a quantity of 1
#    When I update the quantity of "Laptop" to 2
#    Then I should see a success message indicating the quantity update
#    And the updated quantity and total price should reflect in my cart
#
#  Scenario: Removing item from the cart
#    Given "Smartphone" is in my cart
#    When I remove "Smartphone" from my cart
#    Then I should see a success message indicating the item removal
#    And "Smartphone" should no longer be visible in my cart
#
#  Scenario: Placing an order
#    Given I have items in my cart
#    When I proceed to checkout
#    Then my cart should be empty
#    And the inventory of purchased products should be updated accordingly
#    And I should see a success message confirming my order placement
