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
    # Then I should see the message "Your resource has been successfully submitted and will be reviewed!" 

<<<<<<< HEAD


Scenario: adding a resource called "The Coaching Fellowship" with certain fields missing
    Given I am on "/resources/new.html"
    When I fill in "title" with "The Coaching Fellowship"
    And I select "Networks" for "Resource Type"
    And I select "Undergraduate Student" for "Audience"
    And I choose "Global" for "Location"
    When I press "submit_button"
    Then I should not see the message "Your resource has been successfully submitted and will be reviewed!"
    # And I should see the message "Please fill in the required fields."

Scenario: adding a resource called "Women Techmakers" with all its fields but description is too long
    Given I am on "/resources/new.html"
    When I fill in "title" with "Women Techmakers"
    And I fill in "url" with "https://www.womentechmakers.com/"
    And I fill in "Contact Email" with "WTMScholars@google.com"
    And I fill in "Desc" with "According to the Historia Augusta, Hadrian informed the Senate of his accession in a letter as a fait accompli, explaining that "the unseemly haste of the troops in acclaiming him emperor was due to the belief that the state could not be without an emperor".[49] The new emperor rewarded the legions' loyalty with the customary bonus, and the Senate endorsed the acclamation. Various public ceremonies were organized on Hadrian's behalf, celebrating his "divine election" by all the gods, whose community now included Trajan, deified at Hadrian's request.Hadrian remained in the east for a while, suppressing the Jewish revolt that had broken out under Trajan. He relieved Judea's governor, the outstanding Moorish general Lusius Quietus, of his personal guard of Moorish auxiliaries; then he moved on to quell disturbances along the Danube frontier. In Rome, Hadrian's former guardian and current Praetorian Prefect, Attianus, claimed to have uncovered a conspiracy involving four leading senators, who included Lusius Quietus. There was no public trial for the four – they were tried in absentia, hunted down and killed. Hadrian claimed that Attianus had acted on his own initiative, and rewarded him with senatorial status and consular rank; then pensioned him off, no later than 120. Hadrian assured the senate that henceforth their ancient right to prosecute and judge their own would be respected.The reasons for these four executions remain obscure. Official recognition of Hadrian as legitimate heir may have come too late to dissuade other potential claimants. Hadrian's greatest rivals were Trajan's closest friends, the most experienced and senior members of the imperial council; any of them might have been a legitimate competitor for the imperial office (capaces imperii); and any of them might have supported Trajan's expansionist policies, which Hadrian intended to change. One of their number was Aulus Cornelius Palma who as a former conqueror of Arabia Nabatea would have retained a stake in the East. The Historia Augusta describes Palma and a third executed senator, Lucius Publilius Celsus (consul for the second time in 113), as Hadrian's personal enemies, who had spoken in public against him. The fourth was Gaius Avidius Nigrinus, an ex-consul, intellectual, friend of Pliny the Younger and (briefly) Governor of Dacia at the start of Hadrian's reign. He was probably Hadrian's chief rival for the throne; a senator of highest rank, breeding, and connections; according to the Historia Augusta, Hadrian had considered making Nigrinus his heir apparent, before deciding to get rid of him.Soon after, in 125, Hadrian appointed Marcius Turbo as his Praetorian Prefect. Turbo was his close friend, a leading figure of the equestrian order, a senior court judge and a procurator. As Hadrian also forbade equestrians to try cases against senators, the Senate retained full legal authority over its members; it also remained the highest court of appeal, and formal appeals to the emperor regarding its decisions were forbidden. If this was an attempt to repair the damage done by Attianus, with or without Hadrian's full knowledge, it was not enough; Hadrian's reputation"
    And I select "Networks" for "Resource Type"
    And I select "Undergraduate Student" for "Audience"
    And I choose "Global" for "Location"
    When I press "submit_button"
    Then I should not see the message "Your resource has been successfully submitted and will be reviewed!"
    # Then I should see the message "Description was too long."


=======
>>>>>>> origin
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
    
