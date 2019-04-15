Feature: display list of resources filtered by any combination of available tags

  As a web developer in BearX
  I want to make an HTTP GET request to the Innovation Resources API with parameters of audience="X"&type="Y"
  So that I can get JSON/XML data of resource types that are relevant to me.

  Background: resources have been added to database
  
    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses | approval_status |
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Women | 1 |
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring,Scholarship | Other | placeholder | Women | 1 |
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women | 1 |
      | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | fri@ucdavis.edu | Davis | Mentoring | Other | placeholder | Women | 1 |

  Scenario: restrict to resources pertaining to women
    When I make a GET request to "/resources" with parameters: 
      | population_focus |
      |      women       |
    Then I should receive a JSON object
    And the JSON should contain all the resources

  Scenario: restrict to resources that are scholarships
    When I make a GET request to "/resources" with parameters: 
      |    types    |
      | Scholarship |
    Then I should receive a JSON object
    And the JSON should contain "Girls in Engineering of California"
    And the JSON should contain "Girls in Engineering"
    And the JSON should not contain "Society of Women in Engineers"
    And the JSON should not contain "UC Davis Feminist Research Institute"

  Scenario: restrict to resources pertaining to undergraduates
    When I make a GET request to "/resources" with parameters: 
      |   audiences   |
      | Undergraduate |
    Then the JSON should be empty

  Scenario: do not restrict by any tag
    When I make a GET request to "/resources" with no parameters
    Then the JSON should contain all the resources
