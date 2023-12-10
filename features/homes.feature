Feature: Home Page Display

  @needs_log_in
  Scenario: Display home page when user is logged in
    Given I am logged in as a user
    When The user visits the home page
    Then The user should see the home page

  Scenario: Display home page when user is not logged in
    When The user visits the home page
    Then The user should see the home page
