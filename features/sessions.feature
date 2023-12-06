Feature: User Authentication
  Background:
    a user exists with email "test@email.com" and password "P4ssw0rd!"

  @needs_user
  Scenario: Login
    Given I am on the login page
    When I enter valid credentials
    Then I should be redirected to the homepage with a success message

  Scenario: Invalid Login
    Given I am on the login page
    When I enter invalid credentials
    Then I should see an error message

  @needs_user
  Scenario: Logout
    Given I am logged in
    When I log out
    Then I should be redirected to the homepage with a signed-out message

  @needs_user
  Scenario: Registration as a Seller
    Given I am logged in
#    Given I am on the registration page
    Given I am not a seller
    When I register as a seller
    Then I should see a registration success message

  # Google forbids logging in through automated tests
  # https://sqa.stackexchange.com/a/42348
  #Scenario: Omniauth Login
  #  Given I am on the login page
  #  When I log in through Google
  #  Then I should be logged in through Google and see a success message