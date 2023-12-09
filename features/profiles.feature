Feature: User Profiles
  As a user
  I want to manage my profile
  So that I can update or delete my information for others to see

  @needs_log_in
  Scenario: Create a new profile
    Given I am logged in as a user
    And I do not have a profile
    When I go to create a new profile
    Then I should see a profile creation form
    When I fill in the profile creation form with valid information
    And I submit the profile creation form
    Then I should see a profile creation success message
    And My profile should be created with the entered information

  @needs_log_in
  Scenario: Edit my profile
    Given I am logged in as a user
    And I have a profile
    When I go to edit my profile page
    Then I should see the profile edit form
    When I update my profile information
    Then My profile should be updated with the new information

#  Scenario: Attempt to edit someone else's profile
#    Given there is another user with a profile
#    When I try to edit their profile
#    Then I should see an alert that I can only edit my own profile
#
  @needs_log_in
  Scenario: Attempt to create a new profile when I already have one
    Given I am logged in as a user
    And I have a profile
    When I go to create a new profile
    Then I should see an alert that I already have a profile
#
#  Scenario: Show a public profile
#    Given there is a public profile
#    When I view the public profile
#    Then I should see the profile details
#
#  Scenario: Attempt to view a private profile
#    Given there is a private profile
#    When I try to view the private profile
#    Then I should see an alert that the profile is private
#
#  Scenario: Delete my profile
#    Given I have a profile
#    When I go to delete my profile
#    Then I should see a confirmation page to delete my profile
#    When I confirm the deletion
#    Then I should see a success message that my profile was deleted
#    And my profile should no longer exist
