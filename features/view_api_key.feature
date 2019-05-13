Feature: admin user can view own api key

  As a user of the innovation resources website with admin privileges,
  I can click a button to view my own API key,
  So that I can use the innovation resources API with admin privileges.

  Background: must be existing user in the database
    
    Given the following users exist:
      |      email      | password | api_token  |
      |  swe@google.com | password | 1a2b3c4d5e |

  Scenario: guest user cannot view api key button
    Given I am on "/"
    Then I should not see the "View API Key" button inside the "navbar" nav

  Scenario: guest user cannot view api key
    Given I am on "/"
    When I try to visit "user/showkey"
    Then I should be on the welcome page
    And I should not see the "View API Key" button inside the "navbar" nav

  Scenario: admin user can view api key
    Given I am logged in with user "swe@google.com" and password "password"
    And I am on "/"
    Then I should see the text "View API Key"
    When I follow "View API Key"
    Then I should see the text "Your API key is '1a2b3c4d5e'"
    And I should be on the welcome page

  Scenario: admin viewing api key preserves page location
    Given I am logged in with user "swe@google.com" and password "password"
    And I am on "/resources.html"
    Then I should see the text "View API Key"
    When I follow "View API Key"
    Then I should see the text "Your API key is '1a2b3c4d5e'"
    And I should be redirected to the page titled "Resources"
