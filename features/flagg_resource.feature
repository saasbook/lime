Feature: display list of resources filtered by any combination of available tags

  As a web developer in BearX
  I want to make an HTTP GET request to the Innovation Resources API with parameters of audience="X"&type="Y"
  So that I can get JSON/XML data of resource types that are relevant to me.

  Background: resources have been added to database

    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Women
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring,Scholarship | Other | placeholder | Women
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women
      | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | fri@ucdavis.edu | Davis | Mentoring | Other | placeholder | Women



  Scenario: flag a resource
    When I make a PUT request to "/resources/1" with parameters:
      | flagged |
      |    1    |
    Then I should receive a JSON object
    Then I should see "Society of Women Engineers"
    Then the resource should be flagged



#    When I make a PUT request to "/resources" with parameters:
#      | title                        | url | contact_email | location | types | audiences | desc| population_focuses | flagged | flagged_comment |
#      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women | true | bad |
#    Then I should receive a JSON object
#    Then I should see "Society of Women Engineers"
#    Then the JSON should contain "flagged"
#  Scenario: flag a resource
#    When I make a POST request to "/resources" with parameters:
#      | title                        | flagged | flagged_comment |
#      | Society of Women Engineers   | true    | bad             |
#    Then I should receive a JSON object
#
#    Then the JSON should contain "flagged"

