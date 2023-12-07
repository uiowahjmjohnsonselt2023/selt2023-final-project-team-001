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

  Scenario: Create a new storefront
    When I visit the new storefront page
    Then I should see a form to create a new storefront

  Scenario: Preview custom code for a new storefront
    Given I am on the new storefront page
    When I enter custom code in the preview section
    And I click on the 'Preview' button
    Then I should see a preview of the storefront with the custom code

  Scenario: Save custom code for a new storefront
    Given I am on the new storefront page
    When I enter custom code in the save section
    And I click on the 'Save' button
    Then I should be redirected to the storefront page
    And I should see the updated storefront with the custom code

  Scenario: Choose a template for a storefront
    Given I am on the new storefront page
    When I choose a template number
    And I click on the 'Choose Template' button
    Then I should be redirected to the storefront page
    And I should see the selected template applied to the storefront