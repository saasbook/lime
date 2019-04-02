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
    Given I am on the "new resource page"
    When I fill in "Resource name" with "Women Techmakers"
    And I fill in "Resource URL" with "https://www.womentechmakers.com/"
    And I fill in "Email-Contact" with "WTMScholars@google.com"
    And I fill in "Resource Description" with "Google-backed initiative that..."
    And I select "Networks" for "Resource Type"
    And I select "Undergraduate Students" for "Audience"
    And I select "Global" for "Location"
    When I press "Submit"
    Then I should see the message "Your resource has been successfully submitted and will be reviewed!"



Scenario: adding a resource called "The Coaching Fellowship" with certain fields missing
    Given I am on the "new resource page"
    When I fill in "Resource name" with "The Coaching Fellowship"
    And I select "Networks" for "Resource Type"
    And I select "Undergraduate Students" for "Audience"
    And I select "Global" for "Location"
    #When I press "Submit"
    Then I should not see the message "Your resource has been successfully submitted and will be reviewed!"
    # And I should not see "The Coaching Fellowship"

Scenario: adding a resource called "Society of Women Engineers" with itsfields
    When I make a POST request to "/resources" with parameters: 
      | title                        | url | contact_email | location | types | audiences | desc| population_focuses |
      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women |
    Then I should receive a JSON object
    Then I should see "Society of Women Engineers"

Scenario: adding a resource called "Coaching Fellowship Again" with missing other fields
    When I make a POST request to "/resources" with parameters: 
      | title                         | location | types | audiences | desc| population_focuses |
      | Coaching Fellowship Again     | Berkeley | Mentoring | Other | placeholder | Women |
    Then I should not receive a JSON
    And I should not see "Coaching Fellowship Again"
    