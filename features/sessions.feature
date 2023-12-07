Feature: User Authentication
  As a user
  I want to be able to log in and out and register as a seller
  So that I can access and use my account

  Background:
    a user exists with email "test@email.com" and password "P4ssw0rd!"

  @needs_user
  Scenario: Login
    Given I am on the login page
    And I enter valid credentials
    When I click the login button
    Then I should be redirected to the homepage with a success message

  Scenario: Logout
    Given I am logged in
    When I log out
    Then I should be redirected to the homepage with a signed-out message

  Scenario: Registration as a Seller
    Given I am logged in
    And I am not a seller
    When I register as a seller
    Then I should see a registration success message

  # Google forbids logging in through automated tests
  # https://sqa.stackexchange.com/a/42348
  #Scenario: Omniauth Login
  #  Given I am on the login page
  #  When I log in through Google
  #  Then I should be logged in through Google and see a success message

  # Sad paths
  Scenario: Invalid Login
    Given I am on the login page
    And I enter invalid credentials
    When I click the login button
    Then I should see an error message

  @needs_user
  Scenario: Registration as a Seller when already a Seller
    Given I am logged in
    And I am a seller
    When I try to register
    Then I should see a registration failure message

  Scenario: Logout when already not signed in
    Given I am logged in
    And I log out
    And I log out
    Then I should see a logout failure message

  Scenario: Registration when not logged in
    Given I am not logged in
    When I try to register
    Then I should see a not logged in registration failure message

  Scenario: Login when already logged in
    Given I am logged in
    And I try to log in
    Then I should see an already logged in failure message