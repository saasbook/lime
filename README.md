# Innovation Resources Database API and website

[![Maintainability](https://api.codeclimate.com/v1/badges/9fbc73aa3f01f70834b6/maintainability)](https://codeclimate.com/github/andrewlawhh/lime/maintainability)

[![Test Coverage](https://api.codeclimate.com/v1/badges/9fbc73aa3f01f70834b6/test_coverage)](https://codeclimate.com/github/andrewlawhh/lime/test_coverage)

## Table of contents

* Running up the app locally
* Api Usage
    * Getting an API key
    * Api call response format
    * Basic Resource Search
    * Filtering searches
        * location filtering
    * Resource Attributes    
    * Creating new resources
## Running up the app locally
To set up and run the app locally, first run the command  
rake db:reset  
Then set up the app as normal, rake db:setup, and rails s. You MUST run rake db:reset first or you will encounter errors. 
## Api Usage
### Getting an API key
Login to your profile on the website at   
https://berkeley-innovation-resources.herokuapp.com/users/sign_in  
then press the "view api key" button, and an alert will flash with your API key

### Api Call response format
The innovation resources API supports a data response in JSON format.
### Basic Resource Search -- /resources
To retrieve the total list of resources from the innovation resources database, make a GET request 
```
GET /resources?api_key="yourkey"
```

the response will be JSON in the following format

```[
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
 "availabilities":[{"val":"Summer"}],   
 "innovation_stages":[{"val":""}],   
 "topics":[{"val":"Education", "Learning"}],   
 "technologies":[{"val":""}]}  
{"id":2   
...
}
 ]
 ```

### Filtering Searches
The API response for filtered requests will still be in JSON format.

Filtered Requests should be made in the format
```
GET /resources?api_key="yourkey"&{resource attr 1}={desired values seperated by commas}&&{resource attr 2}={desired values seperated by commas}

```
to 
https://berkeley-innovation-resources.herokuapp.com.
#### Location filtering
To Make location searching for the API smarter, when filtering by location, the api will also return resources with 
locations that are "children" of the location that is being filtered by. For instance, if you were to filter by "california", the api
will also return resources that are located in "berkeley" or "davis", or any other location within California.

This location nesting is done when resources are added, and is done using the geocoder gem : https://github.com/alexreisner/geocoder.
### Resource attributes
**All Resources have the following required attributes**
* id - database id of resource
* url - url for the resource
* title - the name of the resource
* desc - description of the resource
* types - resource type tags
* location - where the resource is available
* audiences - who the resource is for 
* contact_email - who should be contacted if there are problems with the resource

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
https://berkeley-innovation-resources.herokuapp.com/resources/new.html

### Creating new resources
To create a new resource, make a POST request to the API in the format:
```
POST /resources?url={resource url}&title={title}&desc={description}&types="type1, type2, ..."&location="loc1, loc2"&audiences="audience1, audience2, ..."&contact_email="contact email here"

```
to 
https://berkeley-innovation-resources.herokuapp.com.
you MUST have the required resource fields listed above, but may add any of the optional fields as well.