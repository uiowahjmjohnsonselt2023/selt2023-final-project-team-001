Feature: Seller Reviews
  As a user
  I want to leave reviews for sellers
  So that I can share my experiences with others

  @needs_user
  Scenario: Leave a review for a seller
    Given I am logged in
    And There is a seller with a profile
    When I go to the new review page for that seller
    Then I should see a form to leave a review
    When I fill in the review form with valid information
    And I submit the review
    Then I should see a success message
    And The seller's profile should show the updated seller rating

  # Sad paths
  Scenario: Attempt to leave a review for oneself
    Given I am on the new review page for my own profile
    Then I should see an alert that I cannot leave a review for myself

  Scenario: Attempt to leave a review for a non-seller
    Given there is a user who is not a seller
    When I go to the new review page for that user
    Then I should see an alert that I cannot leave a review for a non-seller
