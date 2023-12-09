Feature: Password Reset

  @needs_log_in
  Scenario: Requesting a password reset link
    Given I am on the forgot password page
    Then I should see a form to enter my email and confirm email

  @needs_log_in
  Scenario: Requesting a password reset link with mismatched emails
    Given I am on the forgot password page
    When I fill in my email and confirm email with different emails
    And I submit the form
    Then I should see an alert "Emails do not match!"
    And I should stay on the forgot password page
