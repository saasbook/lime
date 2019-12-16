Feature: edit a resource through view
	As an resource owner
	I want to able to manually change details of my resource
	So that I can update my resource.

	Background: resources have been added to database
  
	    Given the following resources exist:
	      | title                        | url | contact_email | location | types | audiences | description | population_focuses | approval_status |
	      | Society of Women Engineers   | http://swe.berkeley.edu | example@example.com  | Berkeley | Mentoring | Alumni | placeholder | Women | 1 |
		  | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Women | 1 |

	    And the following resource owners exist:
	      | email                        | password |
	      | example@example.com          | password |

  	Scenario: edit a resource that belongs to the owner
  		Given I am logged in with email "example@example.com" and password "password" as a resource owner
  		And I follow "Edit"
  		And I fill in "Description" with "describe"
  		And I select "Events" for "Resource Type"
			# Then show me the page
  		And I press "submit_button"
  		Then I should see the message "Resource updated."
  		And I am on "/resources/1.html"
  		Then I should see the text "describe"
  		Then I should see the text "Events"

	Scenario: can't edit a resource
		Given I am logged in with email "example@example.com" and password "password" as a resource owner
		And I am on "/resources/2/edit.html"
		Then I should be on my resources page
		Then I should see the text "You don't have permission to update this record"


  		



