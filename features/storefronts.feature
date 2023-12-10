Feature: Storefronts
  As a seller
  I want to have a storefront
  So that I can sell and advertise my products

  @no_storefronts
  Scenario: View all storefronts with none created
    When I go to the storefronts page
    Then I should see a no storefront message

  @needs_storefronts
  Scenario: View all storefronts with some created
    When I go to the storefronts page
    Then I should see a list of storefronts

  @needs_user
  @no_storefronts
  Scenario: View storefront form
    Given I am logged in
    And I register as a seller
    When I visit the new storefront page
    Then I should see a form to create a new storefront

  @needs_user
  @no_storefronts
  Scenario: Create a new storefront
    Given I am logged in
    And I register as a seller
    When I visit the new storefront page
    And I fill in the storefront form
    Then I should be redirected to the storefront page

  @needs_user
  @no_storefronts
  Scenario: Preview custom code for a new storefront
    Given I am logged in
    And I create a storefront
    When I am on the customize storefront page
    And I enter custom code in the preview section
    And I click on the 'Preview' button
    Then I should see a preview of the storefront with the custom code

  @needs_user
  @no_storefronts
  Scenario: Save custom code for a new storefront
    Given I am logged in
    And I create a storefront
    When I am on the customize storefront page
    And I enter custom code in the preview section
    And I click on the 'Save' button
    Then I should be redirected to the storefront page with custom code

  @needs_user
  @no_storefronts
  Scenario: Choose a template for a storefront
    Given I am logged in
    And I create a storefront
    When I am on the choose template page
    And I click choose this for my storefront
    Then I should be redirected to the storefront page with the template

