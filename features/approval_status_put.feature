Feature: admin edits list of unapproved resources

  As an API user with administrative privileges,
  I want to make a PUT request to the Innovation Resources API to approve one, multiple, or all pending resource(s)
  So that it wll be added to the list of approved resources.

  Background: resources that have been added to the database

    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses | approval_status |
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Women | 1 |
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring,Scholarship | Other | placeholder | Women | 0 |
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women | 1 |
      | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | fri@ucdavis.edu | Davis | Mentoring | Other | placeholder | Women | 1 |
      | Google Scholars              | http://google.com       | google@google.com | Berkeley | Mentoring | Other | Placeholder | All | 0 |

    Given the following users exist:
      |      email     | password | api_token |
      | swe@google.com | password | 123456789 |

  Scenario: guest users cannot approve all resources
    When I make a PUT request to "/resources/approve/many" with parameters:
      | approve_list |
      |     all      |
    Then the "Girls in Engineering" resource should be unapproved
    And the "Google Scholars" resource should be unapproved
    And I should receive a JSON object
    And the JSON should be empty
    And the response status should be "401"

  Scenario: guest users cannot approve multiple resources
    When I make a PUT request to "/resources/approve/many" with parameters:
      | approve_list[] | approve_list[] |
      |       1        |        2       |
    Then the "Girls in Engineering" resource should be unapproved
    And the "Google Scholars" resource should be unapproved
    And I should receive a JSON object 
    And the JSON should be empty
    And the response status should be "401"

  Scenario: admin user can approve all resources
    When I make a PUT request to "/resources/approve/many" with parameters:
      | approve_list |  api_key  |
      |     all      | 123456789 |
    Then all the resources should be approved
    And I should receive a JSON object
    And the JSON should contain all the resources

  Scenario: admin user can approve multiple resources
    When I approve the following resources with api key "123456789":
      |         title        |
      | Girls in Engineering |
      |    Google Scholars   |
    Then all the resources should be approved
    And I should receive a JSON object
    And the JSON should contain "Girls in Engineering"
    And the JSON should contain "Google Scholars"

   Scenario: admin user can approve single resource
     When I approve the following resources with api key "123456789":
       |      title      |
       | Google Scholars |
    Then the "Google Scholars" resource should be approved
    And I should receive a JSON object
    And the JSON should contain "Google Scholars"

  Scenario: admin user formats multiple approval request incorrectly
    When I approve resources "1,2,%5" with api key "123456789"
    Then I should receive a JSON object
    And the JSON should be empty
    And the response status should be "400"
