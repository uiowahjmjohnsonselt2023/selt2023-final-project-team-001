Feature: Price Alerts Management

  @needs_log_in
  Scenario: Creating a new price alert successfully
    Given I am logged in as a different user
    And The following products exist:
      | name       | quantity | price |
      | Smartphone | 10       | 500   |
    When I visit the new price alert page for "Smartphone"
    And I set a price threshold of "400"
    And I submit the price alert form
    Then I should see a success message "Price alert successfully created!"
    And I should be redirected to the price alerts page

  @needs_log_in
  Scenario: Trying to add a price alert for own product
    Given I am logged in as a user
    And The following products exist:
      | name       | quantity | price |
      | Laptop     | 5        | 1000  |
    When I visit the new price alert page for "Laptop"
    Then I should see an alert "You cannot add your own product to your price alerts!"
    And I should be redirected to the homepage

  @needs_log_in
  Scenario: Editing a price alert successfully
    Given I am logged in as a different user
    And The following products exist:
      | name       | quantity | price |
      | Smartphone | 10       | 500   |
    When I visit the new price alert page for "Smartphone"
    And I set a price threshold of "400"
    And I submit the price alert form
    When I visit the edit price alert page for "Smartphone"
    And I update the price threshold to "300"
    And I submit the price alert update form
    Then I should see a success message "Price alert successfully updated!"
    And I should be redirected to the price alerts page


#  Scenario: Deleting a price alert successfully
#    Given I am logged in as a different user
#    And The following products exist:
#      | name       | quantity | price |
#      | Smartphone | 10       | 500   |
#    When I visit the new price alert page for "Smartphone"
#    And I set a price threshold of "400"
#    And I submit the price alert form
#    And I click on the delete button for the "Smartphone" price alert
#    Then I should see a success message "Price alert deleted successfully!"
#    And I should be redirected to the price alerts page
