Feature: view extra info on a resource

	As an non API user
	I want to able to see more info on a resource
	So that I can find out more about a particular resource
	
	Background: resources have been added to database
  
	    Given the following resources exist:
	      | title                        | url | contact_email | location | types | audiences | desc| population_focuses | innovation_stages | approval_status |
	      | Society of Women Engineers   | http://swe.berkeley.edu | swe@berkeley.edu  | Berkeley | Mentoring | Other | placeholder | Women | Research | 1 |

    Scenario: viewing more info on a resource
        Given I am on "/resources.html/"
        When I follow "More info"
        Then I should see the text "Innovation Stages:"
        Then I should see the text "Research"

