Feature: Provider POST to API with resource recommendation

As a resource provider
I want to make a POST request to the Innovation Resources API 
with the minimum requirements for a resource to be added 
so that my resource can be added to the approval queue

Background: database already has other resources

    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses |
      | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Women |
      | Girls in Engineering         | http://gie.berkeley.edu |  gie@berkeley.edu | Berkeley | Mentoring,Scholarship | Other | placeholder | Women |




Scenario: adding a resource called "Women Techmakers" with its other fields
    Given I am on "/resources/new.html"
    When I fill in "title" with "Women Techmakers"
    And I fill in "url" with "https://www.womentechmakers.com/"
    And I fill in "Contact Email" with "WTMScholars@google.com"
    And I fill in "Desc" with "Google-backed initiative that..."
    And I select "Networks" for "Resource Type"
    And I select "Undergraduate Student" for "Audience"
    And I choose "Global" for "Location"
    When I press "submit_button"
    Then I should see the message "Your resource has been successfully submitted and will be reviewed!" 

Scenario: adding a resource called "Society of Women Engineers" with its fields
    When I make a POST request to "/resources" with parameters: 
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses |
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women |
    Then I should receive a JSON object
    And the JSON should contain "Society of Women Engineers"

Scenario: adding a resource called "Coaching Fellowship Again" with missing other fields
    When I make a POST request to "/resources" with parameters: 
      | title                         | location | types | audiences | desc| population_focuses |
      | Coaching Fellowship Again     | Berkeley | Mentoring | Other | placeholder | Women |
    Then I should not receive a JSON
    And the JSON should not contain "Coaching Fellowship Again"
    
