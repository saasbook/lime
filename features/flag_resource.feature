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


  Scenario: flag a resource with no comment
    When I make a PUT request to "/resources/1" with parameters:
      | flagged |
      |    1    |
    Then I should receive a JSON object
    Then I should see "Society of Women Engineers"
    Then the resource should have the attribute "flagged" equal to "1"


  Scenario: flag a resource with a comment
    When I make a PUT request to "/resources/1" with parameters:
      | flagged | flagged_comment   |
      |    1    | this resource bad |
    Then I should receive a JSON object
    Then I should see "Society of Women Engineers"
    Then the resource should have the attribute "flagged" equal to "1"
    Then the resource should have the attribute "flagged_comment" equal to "this resource bad"



