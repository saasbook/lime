Feature: update a resource given certain params

  As an admin
  I want to make an HTTP PUT request for a resource with id="1"
  So that I can update a resource.

  Background: resources have been added to database
  
    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses | approval_status |
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Woman | 1 |
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring | Other | placeholder | Women | 1 |
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women | 1 |
      | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | fri@ucdavis.edu | Davis | Mentoring | Other | placeholder | Women | 1 |

    And the following users exist:
      | email                        | api_token | password |
      | example@example.com          | example      | password |

  Scenario: basic put request using the api_key
      When I make a PUT request to "/resources/1" with parameters: 
          | api_key |
          | example |
      Then I should receive a JSON object

  Scenario: edit flag as an admin
      When I make a PUT request to "/resources/1" with parameters:
        | flagged | flagged_comment   |  api_key  |
        |    1    | this resource bad |   example |
      Then I should receive a JSON object
      Then the JSON should contain "Girls in Engineering of California"
      And the resource should have the attribute "flagged" equal to "1"

      When I make a PUT request to "/resources/1" with parameters:
        | flagged  | api_key |
        |     0    | example |
      Then I should receive a JSON object
      And the JSON should contain "Girls in Engineering of California"
      Then the resource should have the attribute "flagged" equal to "0"

      When I make a GET request to "/resources" with parameters: 
        |               title                |
        | Girls in Engineering of California |
      Then I should receive a JSON object
      Then the first resource should have the attribute "flagged" equal to "0"
    
    Scenario: edit attributes already set for a resource
      When I make a PUT request to "/resources/1" with parameters:
        |       url     |        desc       | api_key |
        |    new_url    | not a placeholder | example |
      Then I should receive a JSON object
      When I make a GET request to "/resources" with parameters: 
        |    title    |
        | Girls in Engineering of California |
      Then I should receive a JSON object
      Then the first resource should have the attribute "url" equal to "new_url"
      Then the first resource should have the attribute "desc" equal to "not a placeholder"

    Scenario: edit attributes initially set as nil for a resource
        When I make a PUT request to "/resources/1" with parameters:
          | contact_name  |  contact_phone  | desc | api_key |
          |    somename    | 111-111-1111 | another placeholder | example |
        Then I should receive a JSON object
        When I make a GET request to "/resources" with parameters: 
          |    title    |
          | Girls in Engineering of California |
        Then I should receive a JSON object
        Then the first resource should have the attribute "desc" equal to "another placeholder"
        Then the first resource should have the attribute "contact_name" equal to "somename"
        Then the first resource should have the attribute "contact_phone" equal to "111-111-1111"

    Scenario: make a post, update its attributes, then get
        When I make a POST request to "/resources" with parameters: 
          | title                 | url | contact_email | location | types | audiences | desc| population_focuses | approval_status | api_key |
          | Coaching Fellowship   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women | 1 | example |
        Then I should receive a JSON object
        And the JSON should contain "Coaching Fellowship"
        When I make a PUT request to "/resources/5" with parameters:
            | notes  |  contact_phone  | desc | api_key |
            |    here are notes   | 222-222-2222 | more placeholder | example |
        Then I should receive a JSON object
        When I make a GET request to "/resources" with parameters: 
            |    title    |
            | Coaching Fellowship |
        Then I should receive a JSON object
        Then the first resource should have the attribute "notes" equal to "here are notes"
        Then the first resource should have the attribute "desc" equal to "more placeholder"
        Then the first resource should have the attribute "contact_phone" equal to "222-222-2222"

        



    

