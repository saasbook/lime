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

    Scenario: adding a resource called "Society of Women Engineers" with itsfields
      When time stands still
      When I make a PUT request to "/resources/1" with parameters:
        | location |
        | San Francisco |
      Then I should receive a JSON object
      Then I should see "San Francisco"
