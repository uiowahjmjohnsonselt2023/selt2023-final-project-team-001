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

  #@needs_log_in
#  Scenario: Trying to add a price alert for own product
#    Given I am logged in as a user
#    And the following products exist:
#      | name       | quantity | price |
#      | Laptop     | 5        | 1000  |
#    When I visit the new price alert page for "Laptop"
#    Then I should see an alert "Cannot add a price alert for your own product!"
#    And I should be redirected to the homepage
#
#  Scenario: Editing a price alert successfully
#    Given I am logged in as "user@example.com"
#    And I have a price alert for "Smartphone" with a threshold of "$400"
#    When I visit the edit price alert page for "Smartphone"
#    And I update the price threshold to "$300"
#    And I submit the updated price alert form
#    Then I should see a success message "Price alert updated successfully!"
#    And I should be redirected to the price alerts page
#
#  Scenario: Trying to edit a price alert that doesn't belong to the user
#    Given I am logged in as "user@example.com"
#    And another user has a price alert for "Smartphone"
#    When I visit the edit price alert page for "Smartphone"
#    Then I should see an alert "You are not authorized to edit this price alert!"
#    And I should be redirected to the homepage
#
#  Scenario: Deleting a price alert successfully
#    Given I am logged in as "user@example.com"
#    And I have a price alert for "Smartphone"
#    When I visit the price alerts page
#    And I click on the delete button for the "Smartphone" price alert
#    Then I should see a success message "Price alert deleted successfully!"
#    And I should be redirected to the price alerts page
#
#  Scenario: Trying to delete a price alert that doesn't belong to the user
#    Given I am logged in as "user@example.com"
#    And another user has a price alert for "Smartphone"
#    When I visit the price alerts page
#    Then I should not see the delete button for the "Smartphone" price alert
