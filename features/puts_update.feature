Feature: update a resource given certain params

  As an admin
  I want to make an HTTP PUT request for a resource with parameters of id="1"
  So that I can update a resource.

  Background: resources have been added to database
  
    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Women
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring,Scholarship | Other | placeholder | Women
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women
      | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | fri@ucdavis.edu | Davis | Mentoring | Other | placeholder | Women

  Scenario: update population focus for women
    When I make a PUT request to "/resources/1" with parameters: 
      | id | desc |
      | 1  |  This is an updated placeholder.   |
    Then I should receive a JSON object
    Then I should see "Girls in Engineering of California"
    Then the resource should have the attribute "desc" equal to "This is an updated placeholder."

