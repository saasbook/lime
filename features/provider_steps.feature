Feature: Provider POST to API with resource recommendation

As a resource provider
I want to make a POST request to the Innovation Resources API 
with the minimum requirements for a resource to be added 
so that my resource can be added to the approval queue

Background: database already has other resources

    Given the following resources are required:
    | Resource | Resource URL | Email-Contact | Resource Description | Resource Type | Audience | Location |

    And I am on the form to upload a resource

Scenario: adding a resource called "Women Techmakers" with its other fields
    When I fill in "Resource name" with "Women Techmakers"
    And I fill in "Resource URL" with "https://www.womentechmakers.com/"
    And I fill in "Email-Contact" with "WTMScholars@google.com"
    And I fill in "Resource Description" with "Google-backed initiative that..."
    And I select "Networks, Fellowships & Scholarships" for "Resource Type"
    And I select "Undergraduate Students, Graduate Students" for "Audience"
    And I select "Global" for "Location"
    When I press "Submit"
    Then I should see "Your resource has been successfully submitted and will be reviewed!"

Scenario: adding a resource called "The Coaching Fellowship" with certain fields missing
    When I fill in "Resource name" with "The Coaching Fellowship"
    And I select "Networks, Mentoring" for "Resource Type"
    And I select "Other" for "Audience"
    And I select "United State" for "Location"
    When I press "Submit"
    Then I should see "Please fill in the required fields."
    And I see the fields "Resource URL, Email-Contact, Resource Description" highlighted red.
    