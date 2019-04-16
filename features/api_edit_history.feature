Feature: Track edits to resources

As a database administrator,
For every change I make to an innovation resource through the API (e.g. PUT, POST, PATCH),
I want the API to record this change with a timestamp,
So that I will have a complete history of edits for every resource present.

Background: database already has the following resources

    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses |
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Women |
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring,Scholarship | Other | placeholder | Women |
    Then the following users exist:
      | email                        | api_token | encrypted_password |
      | example@example.com          | test      | test               |

    Scenario: changing the location of resource Girls in Engineering of California as an admin
     When I make a POST request to "/resources" with parameters:
       | title                         | location | types | audiences | desc| population_focuses |
       | Coaching Fellowship Again     | Berkeley | Mentoring | Other | placeholder | Women |
      Then I should receive a JSON object
      Then I should receive one edit
