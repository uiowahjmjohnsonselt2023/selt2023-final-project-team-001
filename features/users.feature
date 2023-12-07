Feature: Users
  As a user
  I want to be able to sign up and have a profile
  So that I can use the site and share my information

  Background:
  a user exists with email "test@email.com" does not exist

  #Happy paths
  @delete_user?
  Scenario: User signs up
    Given I am on the signup page
    When I fill in with valid information
    Then I should see a signup success message

  Scenario: User can go to login page
    Given I am on the signup page
    When I click on the login link
    Then I should be on the login page

  # Failing to find the dropdown rn
#  @needs_log_in
#  Scenario: Viewing your non existent user profile
#    Given I validly log in
#    And I have no profile
#    When I go to my profile page
#    Then I should be redirected to the profile creation page

  @needs_log_in
  Scenario: Viewing your user profile
    Given I validly log in
    And I have a profile
    When I go to my profile page
    Then I should see my profile


  #Sad paths
  @needs_log_in
  Scenario: User signs up with already taken email
      Given I am on the signup page
      When I fill in with invalid information
      Then I should see a signup failure message

  Scenario: User signs up without field filled in
      Given I am on the signup page
      When I fill in with no information
      Then I should see a field saying to fill it in

  Scenario: User signs up with mismatched passwords
    Given I am on the signup page
    When I fill in with mismatched passwords
    Then I should see a password mismatch message

  Scenario: Try to make profile when not logged in
    Given I am not logged in
    When I go to the profile creation page
    Then I should be redirected to the login page