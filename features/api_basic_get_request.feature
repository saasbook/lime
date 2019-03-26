Feature: display list of resources filtered by any combination of available tags

  As a web developer in BearX
  I want to make an HTTP GET request to the Innovation Resources API with parameters of audience="X"&type="Y"
  So that I can get JSON/XML data of resource types that are relevant to me.

  Background: resources have been added to database

    Given the following resources exist:
      | title                        | url | contact_email | location | types | audiences |
      | Feminist Research Institute  |

    And the following audiences exist
      | resource_id | audience |

    And the following resource_types exist
      | resource_id | resource_type |

  Scenario: restrict to resources pertaining to women
    When I make a GET request to the API with parameters: "population_focus=women"
    Then I should receive a valid reply
    And I should receive a JSON object
    And I should receive "Feminist Research Institute"
    And I should receive "FEM Tech Berkeley"
    And I should receive "Girls in Engineering"
    And I should receive "Core Citris Seed Funding"
    And I should receive "Graduate Women in Engineering"

  Scenario: restrict to resources located in Bay Area
    When I make a GET request to the API with parameters: "location=bay_area"
    Then I should receive a JSON object
    And I should receive "Girls in Engineering"
    And I should receive "BERKELEYBESSA"
    And I should receive "Berkeley STEM Equity and Inclusion Initiative"
    And I should receive "Stanford Clayman Institute for Gender Research"
    And I should receive "Global Social Venture Competition"
    And I should receive "Berkeley Blockchain Xcelerator"
    And I should receive "Berkeley SkyDeck Accelerator"
    And I should receive "Berkeley Cleantech University Prize (CUP)"
    And I should receive "Berkeley Angel Network"
    And I should receive "Anita Bord Institute"
    And I should receive "Lean In"

  Scenario: restrict to resources that are scholarships
    When I make a GET request to the API with parameters: "resource_type=scholarship"
    Then I should receive "MPower Financing WOMEN IN STEM SCHOLARSHIP"
    And I should receive "Zonta International Women in Technology Scholarship"
    And I should receive "Box Diversity Scholarship"
    And I should receive "Jack Larson Scholarship-Graduate"
    And I should receive "Jack Larson Scholarship-undergraduate"
    And I should receive "Mildred Jordan Sharp Scholarship"
    And I should receive "Institute of International Studies Undergraduate Merit Scholarship"
    And I should receive "Berkeley Research on Contemporary India Program (BRCIP) Scholarship"

  Scenario: restrict to resources pertaining to undergraduates
    When I make a GET request to the API with parameters: "audience=undergraduate"
    Then I should receive "Feminist Research Institute"
    And I should receive "FEM Tech Berkeley"
    And I should receive "Society of Women Engineers"
    And I should receive "Women in Science and Engineering Theme Program (WiSE)"
    And I should receive "BERKELEYBESSA"
    And I should receive "The Hispanic Engineers and Scientists (HES)"
    And I should receive "Association of Women in EECS (AWE)"
    And I should receive "Berkeley STEM Equity and Inclusion Initiative"
    And I should receive "Phi Sigma Rho - Female Engineering/STEM sorority"
    And I should receive "Women Techmakers"
    And I should receive "Committee on the Status of Women in Computing Research"
    And I should receive "American Indian Science and Engineering Society"
    And I should receive "ACM Richard Tapia Celebration of Diversity in Computing"
    And I should receive "Adobe Research Women-in-Technology"
    And I should receive "Out in Science, Technology, Engineering and Mathematics"
    And I should receive "SMART Mentoring"
    And I should receive "MPower Financing WOMEN IN STEM SCHOLARSHIP"
    And I should receive "Next Generation Women Leaders award"
    And I should receive "Zonta International Women in Technology Scholarship"
    And I should receive "Box Diversity Scholarship"
    And I should receive "Innovation Grants"
    And I should receive "Major Insights Mentorship"
    And I should receive "Getting into Graduate School (GiGS) Mentors"
    And I should receive "International Peer Mentorship Program"
    And I should receive "Berkeley Career Network"
    And I should receive "National Center for Women in Information Technology"
    And I should receive "Girl Geek Dinner"
    And I should receive "Women in Science & Engineering Leadership Institute (WISELI)"
    And I should receive "UC Davis Feminist Research Institute"
    And I should receive "Stanford Clayman Institute for Gender Research"
    And I should receive "Center for Women in Technology (CWIT)"
    And I should receive "Black Engineers Association (BEA)"
    And I should receive "Society of Women Engineers at UC Davis"
    And I should receive "CALESS"
    And I should receive "STEM Resource Center"
    And I should receive "Ingenieros Unidos"
    And I should receive "National Society of Black Engineers (UC Merced)"
    And I should receive "National Society of Black Engineers (UC Santa Cruz)"
    And I should receive "Society of Hispanic Professional Engineers"
    And I should receive "Stanford Women in Technology"

  Scenario: do not restrict by any tag
    When I make a GET request to the API with no parameters
    Then I should receive all the resource

  Scenario: restrict by deadline
    When I make a GET request to the API with parameters: "deadline="
    Then I should receive a JSON object
    And I should receive