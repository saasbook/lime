Feature: admin gets list of unapproved resources

  As an API user with administrative privileges,
  I want to make a GET request to the Innovation Resources API to view the approval queue
  So that I can see which resources need to be approved.

  Background: resources that have been added to the database

    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses | approval_status |
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Women | 1 |
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring,Scholarship | Other | placeholder | Women | 1 |
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women | 1 |
      | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | fri@ucdavis.edu | Davis | Mentoring | Other | placeholder | Women | 1 |
      | Google Scholars              | http://google.com       | google@google.com | Berkeley | Mentoring | Other | Placeholder | All | 0 |

    Given the following users exist:
      |      email     | password | api_token |
      | swe@google.com | password | 123456789 |

  Scenario: guest users cannot view unapproved resources
    When I make a GET request to "/resources" with parameters:
      | approval_status |
      |        0        |
    Then I should receive a JSON object
    And the JSON should contain "Girls in Engineering of California"
    And the JSON should contain "Girls in Engineering"
    And the JSON should contain "Society of Women Engineers"
    And the JSON should contain "UC Davis Feminist Research Institute"
    And the JSON should not contain "Google Scholars"

  Scenario: admin users can view unapproved resources only
    When I make a GET request to "/resources" with parameters:
      | approval_status | api_key   |
      |         0       | 123456789 |
    Then I should receive a JSON object
    And the JSON should contain "Google Scholars"
    And the JSON should not contain resources other than "Google Scholars"

  Scenario: admin users can view both approved and unapproved resources
    When I make a GET request to "/resources" with parameters:
      |  api_key  |
      | 123456789 |
    Then I should receive a JSON object
    And the JSON should contain all the resources

  Scenario: guest users cannot view unapproved resources (HTML, direct)
    Given I am on "/resources/unapproved.html"
    Then I should be redirected to the page titled "Resources"
    And I should not see the "Approval Queue" button inside the "navbar" nav

  Scenario: admin users can view approval queue html page
    Given I am logged in with user "swe@google.com" and password "password"
    And I am on "/resources/unapproved.html"
    Then I should see all the unapproved resources
