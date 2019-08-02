Feature: edit a resource through view

	As an admin
	I want to able to manually change details of a resource
	So that I can update a resource.


	Background: resources have been added to database
  
	    Given the following resources exist:
	      | title                        | url | contact_email | location | types | audiences | description | population_focuses | approval_status |
	      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Alumni | placeholder | Women | 1 |

	    And the following users exist:
	      | email                        | api_token | password |
	      | example@example.com          | example      | password |

  	Scenario: edit a resource
  		Given I am logged in with user "example@example.com" and password "password"
  		And I am on "/resources/1.html"
  		And I follow "Edit"
  		And I fill in "Description" with "describe"
  		And I select "Events" for "Resource Type"
			# Then show me the page
  		And I press "submit_button"
  		Then I should see the message "Resource updated."
  		And I am on "/resources/1.html"
  		Then I should see the text "describe"
  		Then I should see the text "Events"


  		



