Feature: Error Handling

  #Capybara refuses to actually go to the page, so I can't test this
  # No route matches [GET] "/non-existing-page" (ActionController::RoutingError)
#  Scenario: Display 404 Not Found Error Page
#    Given A user requests a non-existing page
#    Then The user encounters a 404 error
#    And They should see the "Not Found" page

  #I cannot for the life of me figure out how to stub this in capybara, I'm not good enough yet
#  Scenario: Display 500 Internal Server Error Page
#    Given an internal server error occurs
#    When the user encounters a 500 error
#    Then they should see the "Internal Server Error" page
