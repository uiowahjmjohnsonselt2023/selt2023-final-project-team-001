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

  @needs_log_in
  Scenario: Updating cart item quantity
    Given The following products exist:
      | name           | quantity | price |
      | Laptop         | 5        | 1000  |
    And "Laptop" is in my cart with a quantity of "1"
    When I update the quantity of "Laptop" to "2"
    Then I should see a success message indicating the quantity update
    And The updated quantity and total price should reflect in my cart

  #this can't be completely tested as it uses js
  @needs_log_in
  Scenario: Removing item from the cart
    Given The following products exist:
      | name           | quantity | price |
      | Smartphone     | 8        | 800   |
    And "Smartphone" is in my cart with a quantity of "1"
    When I remove "Smartphone" from my cart
    Then I should see a confirmation popup
#    And The "Smartphone" should no longer be in my cart
