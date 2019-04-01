Feature: display list of resources filtered by any combination of available tags

  As a web developer in BearX
  I want to make an HTTP GET request to the Innovation Resources API with parameters of audience="X"&type="Y"
  So that I can get JSON/XML data of resource types that are relevant to me.

  Background: resources have been added to database
  
    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Women
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring,Scholarship | Other | placeholder | Women
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women
      | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | fri@ucdavis.edu | Davis | Mentoring | Other | placeholder | Women

  Scenario: restrict to resources pertaining to women
    When I make a GET request to the API with parameters: "population_focus=women"
    Then I should receive a valid reply
    Then I should receive "Girls in Engineering of California"
    And I should receive "Girls in Engineering"
    And I should receive "Society of Women Engineers"
    And I should receive "UC Davis Feminist Research Institute"

  Scenario: restrict to resources that are scholarships
    When I make a GET request to the API with parameters: "types=Scholarship"
    Then I should receive a valid reply
    And I should receive "Girls in Engineering of California"
    And I should receive "Girls in Engineering"

  Scenario: restrict to resources pertaining to undergraduates
    When I make a GET request to the API with parameters: "audiences=Undergraduate"


  Scenario: do not restrict by any tag
    When I make a GET request to the API with no parameters
    Then I should receive all the resources

  Scenario: restrict by deadline

  Scenario: malformed API request
    # should be notified that the request was malformed
    When I make a GET request to the API with parameters: "titl=Feminist Research Institute"
    Then I should receive
