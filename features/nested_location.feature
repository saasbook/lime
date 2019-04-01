Feature: display list of resources filtered by any combination of available tags

  As a web developer in BearX
  I want to make an HTTP GET request to the Innovation Resources API with parameters of audience="X"&type="Y"
  So that I can get JSON/XML data of resource types that are relevant to me.

  Background: resources have been added to database

    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc|
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring | Other | placeholder |
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring | Other | placeholder |
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder |
      | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | fri@ucdavis.edu | Davis | Mentoring | Other | placeholder |


    And the following locations exist
      | location    | parent    |
      | USA         | Global    |
      | California  | USA       |
      | Berkeley    | California|
      | Davis       | California|
      | Stanfurd    | California|
      | Siberia     | Global    |


  Scenario: search for all resources within California
    When I make a GET request to the API with parameters: 
      |  location  |
      | California |
    Then I should receive a JSON object
    And I should receive "Girls in Engineering of California"
    And I should see no other resources

  Scenario: search for all resources within California and Berkeley
    When I make a GET request to the API with parameters: "location=california,Berkeley"
    Then I should receive a JSON object
    And I should receive "Girls in Engineering of California"
    And I should see no other resources

  Scenario: if no resources available, return parent locations resources
    When I make a GET request to the API with parameters: "location=Stanfurd"
    Then I should receive a JSON object
    And I should receive "Girls in Engineering of California"
    And I should see no other resources

  Scenario: search for resources in a location with no children
    When I make a GET request to the API with parameters: "location=Berkeley"
    Then I should receive a JSON object
    And I should receive "Girls in Engineering of California"
    And I should receive "Girls in Engineering"
    And I should receive "Society of Women Engineers"
    And I should see no other resources

  Scenario: search for resources at a location with no resources or parent
    When I make a GET request to the API with parameters: "location=Berkeley"
    Then I should receive a JSON object
    And it should be empty
