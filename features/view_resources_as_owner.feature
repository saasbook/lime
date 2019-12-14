Feature: view resources owned by the resource owner

	As an resource owner
	I want to able to see a list of my resource
	So that I can manage my resources.


	Background: resources have been added to database
  
	    Given the following resources exist:
	      | title                        | url | contact_email | location | types | audiences | description | population_focuses | approval_status |
	      | Society of Women Engineers   | http://swe.berkeley.edu | example@example.com  | Berkeley | Mentoring | Alumni | placeholder | Women | 1 |
		  | Girls in Engineering of California | http://gie.uc.edu |  gie@uc.edu | California | Mentoring,Scholarship | Other | placeholder | Women | 1 |
		  | UC Davis Feminist Research Institute | https://fri.ucdavis.edu/ | example@example.com | Davis | Mentoring | Other | placeholder | Women | 1 |
	    And the following resource owners exist:
	      | email                        | password |
	      | example@example.com          | password |

  	Scenario: view owned resources as the owner
  		Given I am logged in with email "example@example.com" and password "password" as a resource owner
  		Then I should see the text "Society of Women Engineers"
  		Then I should see the text "UC Davis Feminist Research Institute"
		Then I should not see the text "Girls in Engineering of California"



  		



