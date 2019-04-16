Feature: update a resource given certain params

  As an admin
  I want to make an HTTP PUT request for a resource with parameters of id="1"
  So that I can update a resource.

  Background: resources have been added to database
  
    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses |
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Woman |
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring,Scholarship | Other | placeholder | Women |
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women |
      | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | fri@ucdavis.edu | Davis | Mentoring | Other | placeholder | Women |

      Then the following users exist:
      | email                        | api_token | encrypted_password |
      | example@example.com          | test      | test               |

    Scenario: flag a resource with a comment
    When I make a PUT request to "/resources/1" with parameters:
      | flagged | flagged_comment   |
      |    1    | this resource bad |
    Then I should receive a JSON object
    Then I should see "Girls in Engineering of California"
    Then the resource should have the attribute "flagged" equal to "1"

    Scenario: flag a resource with a comment
    When I make a PUT request to "/resources/1" with parameters:
      | flagged | flagged_comment   |
      |    2    | this resource ok |
    Then I should receive a JSON object
    Then I should see "Girls in Engineering of California"
    Then the resource should have the attribute "flagged" equal to "2"

    # Scenario: restrict to resources pertaining to women
    When I make a GET request to "/resources" with parameters: 
      |    types    |
      | Scholarship |
    Then I should receive a JSON object

    # Scenario: update description for a resource
    When I make a PUT request to "/resources/1" with parameters: 
        | |
        | |
        Then I should receive a JSON object
        Then the resource should have the attribute "flagged" equal to "2"
        # Then I should see "Girls in Engineering of California"
        # Then the resource should have the attribute "funding_amount" equal to "10"

