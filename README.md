# Innovation Resources Database API and website

[![Maintainability](https://api.codeclimate.com/v1/badges/b9caa915bcbf59ff9007/maintainability)](https://codeclimate.com/github/katrinapriya/lime/maintainability)

[![Test Coverage](https://api.codeclimate.com/v1/badges/b9caa915bcbf59ff9007/test_coverage)](https://codeclimate.com/github/katrinapriya/lime/test_coverage)

[![Build Status](https://travis-ci.org/katrinapriya/lime.svg?branch=master)](https://travis-ci.org/katrinapriya/lime)

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

Updated Instructions located here: https://docs.google.com/document/d/1HpYSommVZR1MPA-kOLD-GGaOVWxH0wGZdXNHs1vlN3M/edit?usp=sharing

To set up and run the app locally, first set up postgres.  
Run `psql postgres` in terminal.   
Create a new user: `create user postgres;`  
Change the role: `alter user postgres createdb;`  
Use `\du` to check users and their roles  
Make sure user is a super user with `alter user postgres superuser`  
Exit with `\q`

run `rake db:reset`  
Then set up the app as normal, `rake db:setup`, and `rails s`.  
You MUST run rake db:reset first or you will encounter errors. 
## Api Usage
### Getting an API key
Login to your profile on the website at   
https://innovationresourcedatabase.herokuapp.com/users/sign_in  
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
 "description":"description string",   
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
* description - description of the resource
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
https://innovationresourcedatabase.herokuapp.com/resources/new.html

### Creating new resources
To create a new resource, make a POST request to the API in the format:
```
POST /resources?url={resource url}&title={title}&description={description}&types="type1, type2, ..."&location="loc1, loc2"&audiences="audience1, audience2, ..."&contact_email="contact email here"

```
to 

https://innovationresourcedatabase.herokuapp.com.

you MUST have the required resource fields listed above, but may add any of the optional fields as well.

## Creating an Admin account

To gain administrative access to the website, you will be required to have a "Registration key" that will be given by someone who has control of the database.

If you are managing the SQL database of a deployed version of the website, the registration key can be manually edited as long as the key is properly hashed.

## Automatic Emails

The app can currently send automatic emails to resource owners who have approved resources on the website. There are four type of emails being sent out:
* Broken URL emails
* Annual emails (sent to resource owners who have approved resources that have not been updated for a year)
* Expired event emails
* Approval emails (sent to resource owners upon approval of a resource)

The script for sending these emails are located in `lib/tasks/scheduler.rake`, and the HTML templates for these emails are lcoated in `app/views/user_mailer`. Each type of email has three templates: one for the initial email, one for the first reminder after the initial, and one for the second reminder after the initial. The script should be scheduled to run daily on Heroku scheduler. For example, one of the tasks inside `scheduler.rake` is called `send_annual_reminder_email`; to schedule it daily, it should be added to Heroku scheduler like so:
![Heroku Schedule Imgur](https://i.imgur.com/JBvaW4R.png)


All email templates include a link to the sign in page for resource owners to click on. It is very important to to modify the `config.action_mailer.default_url_options` line in `/config/environments/production.rb` to the appropriate Heroku host name to make sure that the sign-in link in emails work. For example, if the website is hosted at `https://berkeleyinnovres.herokuapp.com`, then this line should be
```ruby
config.action_mailer.default_url_options = { :host => 'https://berkeleyinnovres.herokuapp.com' }
```

The appropriate environment variables must be set locally or in production in order for emails to send. An environment variable called `GMAIL_USERNAME` corresponds to the Gmail address that the app sends emails from, and another environment called `GMAIL_PASSWORD` corresponds to the Gmail password for the Gmail account. The credentials will be given by someone who has control of the database.

## Resource Owners

To add existing users of the database as a resource owners (this should be only run once on production), run `heroku run rake add_resource_owners` from your local terminal. This will also send out an email to all resourec owners with their account credentials.

## The BrokenURL tag
The BrokenURL tag is a special tag that is automatically updated on a daily basis. This tag is only viewable for admins. Basically if the URL of the resource is NOT valid, this tag will automatically appear. 

There are 2 ways to untag a BrokenURL tag:
Manually untag the resource from the admins edit page
Edit the URL manually and then wait 24 hours for our automatic Broken URL detection algorithm to pick up the tag

Note: Automatic Broken URL detection occurs 12 AM Pacific Standard Time every day.
