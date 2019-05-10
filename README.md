# Innovation Resources Database API and website

[![Maintainability](https://api.codeclimate.com/v1/badges/9fbc73aa3f01f70834b6/maintainability)](https://codeclimate.com/github/andrewlawhh/lime/maintainability)

[![Test Coverage](https://api.codeclimate.com/v1/badges/9fbc73aa3f01f70834b6/test_coverage)](https://codeclimate.com/github/andrewlawhh/lime/test_coverage)

## Table of contents

* Api Usage
    * Getting an API key
    * Basic Resource Search
    * Resource Attributes
    * Filtering searches
        * available resource types
        * location search
    * Creating new resources

## Getting an API key
TODO : fill in

## Api Calls
The innovation resources API supports a data response in JSON format.
### Basic Resource Search -- /resources
To retrieve the total list of resources from the innovation resources database, make a GET request to the url TODO: insert full url here
/resources?api_key="yourkey"

the response will be JSON in the following format

[
{"id":1,
 "title":"Resource Title", 
 "url":"www.exampleurl.com", 
 "contact_email":"foo@exampleurl.com", 
 "desc":"description string", 
 "resource_email":"foo@exampleurl.com", 
 "resource_phone":"(100) 100-1000", 
 "address":"101 Sproul Hall, Berkeley, CA 94720", 
 "contact_name":"name", 
 "contact_phone":"phone number", 
 "deadline":"2019-01-03T00:00:00.000Z", 
 "notes":"any notes on the resource", 
 "funding_amount":"10000", 
 "location":"Bay Area", 
 "approval_status":1, 
 "approved_by":"", 
 "flagged":null, 
 "flagged_comment":"", 
 "created_at":"2019-05-06T19:48:20.949Z", 
 "updated_at":"2019-05-06T19:48:20.949Z", 
 "types":[{"val":"Events"},{"val":"Mentoring"}], 
 "audiences":[{"val":"Other"}], 
 "client_tags":[{"val":"WITI"}],
 "population_focuses":[{"val":"Women"},{"val":"Under-represented minority"}], 
 "campuses":[{"val":"Berkeley"}], 
 "colleges":[{"id":1,"resource_id":1,"val":"","created_at":"2019-05-06T19:48:21.057Z", 
 "updated_at":"2019-05-06T19:48:21.057Z"}], 
 "availabilities":[{"val":"Summer"}], 
 "innovation_stages":[{"val":""}], 
 "topics":[{"val":"Education \u0026 Learning"}], 
 "technologies":[{"val":""}]}
{"id":2 
...
}
 ]

### Resource attributes
**All Resources have the following required attributes**
* id - database id of resource
* url - url for the resource
* title - the name of the resource
* desc - description of the resource
* types - resource type tags
* location - where the resource is available
* audiences - who the resource is for 

**Resources may also contain the following optional attributes**
* campuses - college campuses the resource is available to
* client_tags - who the resource is hosted by
* innovation_stages - what stage of innovation the resource is aimed at 
    * Research-Academia, Project, Startups, ect.
* population_focuses - who the resource is focused on helping
* availabilities - type of availability for the resource
    * rolling, summer, one-time, ect. 
* topics - what the resource is for
    * Education & Learning, Space, Health & Biotech, ect. 
* technologies
    * Networks, Internet of Things, Cyber Security, ect.
* deadline - when the resource expires
* notes 

For more information on the values each attribute can hold, please visit
TODOURL /resources/new.html

### Filtering Searches
The API response for filtered requests will still be in JSON format.

Filtered Requests should be made in the format

TODO-FILL IN URL/resources?api_key="your api key"&{resource attr 1}={desired values seperated by commas}&&{resource attr 2}={desired values seperated by commas}


