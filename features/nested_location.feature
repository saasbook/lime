Feature: display list of resources filtered by any combination of available tags

  As a web developer in BearX
  I want to make an HTTP GET request to the Innovation Resources API with parameters of audience="X"&type="Y"
  So that I can get JSON/XML data of resource types that are relevant to me.

  Background: resources have been added to database

    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| approval_status |
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring | Other | placeholder | 1 |
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring | Other | placeholder | 1 |
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | 1 |
      | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | fri@ucdavis.edu | Davis | Mentoring | Other | placeholder | 1 |


    And the following locations exist
      | location    | parent    |
      | USA         | Global    |
      | California  | USA       |
      | Alameda     | California|
      | Berkeley    | Alameda   |
      | Davis       | California|
      | Stanfurd    | California|
      | Siberia     | Global    |


  Scenario: search for all resources within California
    When I make a GET request to "/resources" with parameters:
      |  location  |
      | California |
    Then I should receive a JSON object
    And the JSON should contain "Girls in Engineering of California"
    And the JSON should contain "Girls in Engineering"
    And the JSON should contain "Society of Women Engineers"
    And the JSON should not contain "UC Davis Feminist Research Institute"

  Scenario: search for all resources within California and Berkeley
    When I make a GET request to "/resources" with parameters:
      |  location  |
      | California |
      |  Berkeley  |
    Then I should receive a JSON object
    And the JSON should contain "Girls in Engineering of California"
    And the JSON should contain "Girls in Engineering"
    And the JSON should contain "Society of Women Engineers"
    And the JSON should not contain "UC Davis Feminist Research Institute"

  Scenario: if no resources available, return child locations resources
    When I make a GET request to "/resources" with parameters:
      | location |
      | Alameda  |
    Then I should receive a JSON object
    And the JSON should contain "Girls in Engineering"
    And the JSON should contain "Society of Women Engineers"

  Scenario: search for resources in a location with no children
    When I make a GET request to "/resources" with parameters:
      | location |
      | Berkeley |
    Then I should receive a JSON object
    And the JSON should contain "Girls in Engineering"
    And the JSON should contain "Society of Women Engineers"

  Scenario: search for resources at a location with no resources or children
    When I make a GET request to "/resources" with parameters:
      |  location |
      | Roseville |
    Then I should receive a JSON object
    And the JSON should be empty

  Scenario: search for resources at only one location
    When I make a GET request to "/resources" with parameters:
      | location | exclusive |
      |   Davis  |   true    |
    Then I should receive a JSON object
    And the JSON should contain "UC Davis Feminist Research Institute"
    And the JSON should not contain resources other than "UC Davis Feminist Research Institute"

  Scenario: search for a resource with no resources exclusively
    When I make a GET request to "/resources" with parameters:
      |  location |
      | Roseville |
    Then I should receive a JSON object
    And the JSON should be empty


    
