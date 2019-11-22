require 'rspec'
require 'rails_helper'

RSpec.describe ResourcesController, :type => :controller do
  #describe 'Responds successfully' do
    #it 'returns the right HTTP response codes' do
      #get :index
      #expect(response.status).to eq 200
      #get :show, params: {format: :json, id: 1}
      #expect(response.status).to eq 200
      #post :create, params: {format: :html}
      #expect(response.status). to eq 204
    #end
  #end

  describe 'model filter method is called upon GET request' do
    #it 'calls the model method that performs the database filtering' do
      #params = ActionController::Parameters.new(  {types: "Events,Mentoring"} )
      #params.permit!
      
      #expect(Resource).to receive(:filter).with(params)
      #get :index, params: {:types => 'Events,Mentoring'}

    #end
  end

  describe 'only allows admins to GET unapproved resources' do

    it 'doesnt allows guests to view GET unapproved resources' do
      User.delete_all
      response = get :unapproved, params: {}, :format => :json
      expect(response.status).to eq 400
    end

  end

  describe "POST create" do
    it 'calls the correct model method' do
      params = ActionController::Parameters.new({title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "Berkeley", types: 'scholarship,funding', audiences: 'grad,undergrad', description: "descriptions", approval_status: 0, flagged: 0})
      params.permit!
      expect(Resource).to receive(:create_resource).with(params)
      post :create, params: {title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "Berkeley", types: 'scholarship,funding', audiences: 'grad,undergrad', description: "descriptions"}
    end
  end

  describe "GET new" do
    #it 'succeeds' do
      #response = get :new, params: {}
      #expect(response.status).to eq 200
    #end
  end

  describe "GET edit" do
    it "does not allow guests to visit the edit page for a resource" do
      response = get :edit, params: {id: 1}
      response.should redirect_to '/resources.html'
    end
  end

  describe "PATCH update" do
    it 'calls the correct model method' do
      resource = Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "Global",
                               "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "description" => "descriptions"
      User.delete_all
      User.create!(:email => 'example@gmail.com', :password => 'password', :api_token => 'example')
      params = ActionController::Parameters.new({title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "Berkeley", types: 'scholarship,funding', audiences: 'grad,undergrad', description: "descriptions"})
      params.permit!

      # test allowed to update
      expect(Resource).to receive(:update_resource).with(resource.id.to_s, params)
      patch :update, params: {id: resource.id, title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "Berkeley", types: 'scholarship,funding', audiences: 'grad,undergrad', description: "descriptions", api_key: "example"}, :format => :json

      # test not allowed to update without valid api key
      expect(Resource).not_to receive(:update_resource)
      patch :update, params: {id: resource.id, api_key: 'invalid', flagged: 0}, :format => :json
    end

    it 'calls the correct model method but for an unassigned attribute' do
      resource = Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "Global",
                               "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "description" => "descriptions"
      User.delete_all
      User.create!(:email => 'example@gmail.com', :password => 'password', :api_token => 'example')
      params = ActionController::Parameters.new({title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "Berkeley", types: 'scholarship,funding', audiences: 'grad,undergrad', description: "descriptions", contact_name: "contact"})
      params.permit!

      # test allowed to update
      expect(Resource).to receive(:update_resource).with(resource.id.to_s, params)
      patch :update, params: {id: resource.id, title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "Berkeley", types: 'scholarship,funding', audiences: 'grad,undergrad', description: "descriptions", contact_name: "contact", api_key: "example"}, :format => :json
    end



    it "doesn't call update for guests who try to update values they are not permitted to" do
      resource = Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "Global",
                                          "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "description" => "descriptions"
      params = ActionController::Parameters.new({title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "Berkeley", types: 'scholarship,funding', audiences: 'grad,undergrad', description: "descriptions"})
      params.permit!

      # test not allowed to update values
      expect(Resource).not_to receive(:update_resource)
      patch :update, params: {id: resource.id, title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "Berkeley", types: 'scholarship,funding', audiences: 'grad,undergrad', description: "descriptions"}, :format => :json

      # test not allowed to unflag
      expect(Resource).not_to receive(:update_resource)
      patch :update, params: {id: resource.id, flagged: 0}, :format => :json

      # test not allowed to insert garbage values into flagged
      expect(Resource).not_to receive(:update_resource)
      patch :update, params: {id: resource.id, flagged: 'asdfasdf'}, :format => :json

      # test not allowed without a valid api_key
      expect(Resource).not_to receive(:update_resource)
      patch :update, params: {id: resource.id, api_key: 'invalid', flagged: 0}, :format => :json
    end

    it 'lets guests flag resources' do
      resource = Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "Global",
                                          "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "description" => "descriptions"
      params = ActionController::Parameters.new({"flagged" => 1})
      params.permit!

      # test allowed to flag without api key
      expect(Resource).to receive(:update_resource).with(resource.id.to_s, params)
      patch :update, params: {id: resource.id, flagged: 1}
    end
  end

  describe "PUT approve_many" do
    before(:each) do
      Resource.destroy_all
      @resource1 = Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "Global",
                                          "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "description" => "descriptions", "approval_status" => 0

      @resource2 = Resource.create_resource "title" => "thing2", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "Global",
                                          "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "description" => "descriptions", "approval_status" => 0

      @resource3 = Resource.create_resource "title" => "thing3", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "Global",
                                          "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "description" => "descriptions", "approval_status" => 0

      User.delete_all
      User.create!(:email => 'example@gmail.com', :password => 'password', :api_token => 'example')
    end
    
    it 'does not work for unauthorized users' do
      # test allowed to approve only one
      expect(Resource).not_to receive(:update_resource)
      response = put :approve_many, params: {id: @resource1.id}, :format => :json
      expect(response.status).to eq 401
    end

    it 'does not work if an incorrect approval status is provided' do
      # test incorrect approval status set
      response = put :approve_many, params: {id: @resource1.id, approval_status: 2, api_key: 'example'}, :format => :json
      expect(response.status).to eq 403
    end

    it 'will approve all resources if approve_list is set to all in the parameters' do
      # test approve all method
      response = put :approve_many, params: {:approve_list => 'all', approval_status: 1, api_key: 'example'}, :format => :json
      expect(response.status).to eq 200
      expect(Resource.where(:approval_status => 0)).to be_empty
      expect {
        expect(JSON.parse(response.body).length).to eq 3
      }.not_to raise_error
    end

    it 'approves multiple resources if provided as a comma separated list' do
      # test approve multiple 
      response = put :approve_many, params: {:approve_list => ["#{@resource1.id}","#{@resource2.id}"], approval_status: 1, api_key: 'example'}, :format => :json
      expect(response.status).to eq 200
      expect(Resource.where(:approval_status => 0).length).to eq 1
      expect(Resource.where(:approval_status => 0).first).to eq @resource3
      expect {
        json = JSON.parse(response.body)
        expect(json.length).to eq 2
        expect(json.any? {|r| r["id"] == @resource3.id}).to be false
      }.not_to raise_error
    end

    it 'does not approve multiple if an incorrectly formatted list is provided' do
     # test approve multiple, bad format
     response = put :approve_many, params: {:approve_list => ["1","2","$"], approval_status: 1, api_key: 'example'}, :format => :json
     expect(response.status).to eq 400
    end

    it 'does not error out when ids are provided for resources that do not exist' do
     # test approve multiple, ids not found
     response = put :approve_many, params: {:approve_list => ["100","200"], approval_status: 1, api_key: 'example'}, :format => :json
     expect(JSON.parse(response.body)).to be_empty
    end
  end


  #RSpec test for Broken URL feature
  describe "Testing Broken URL Tag" do
    before (:each) do
            Resource.destroy_all
            @resource_goodURL1 = Resource.create_resource "title" => "thing1", "url" => "http://www.goggle.com", "contact_email" => "something@gmail.com", "location" => "Global",
                                                "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "description" => "descriptions", "approval_status" => 0

            @resource_badURL1 = Resource.create_resource "title" => "thing2", "url" => "adksjfdlsajfdbadURL", "contact_email" => "something@gmail.com", "location" => "Global",
                                                "types" => 'Events,Scholarship', "audiences" => 'Grad,Undergrad', "description" => "descriptions", "approval_status" => 0

            @resource_taggedBrokenURLAlready= Resource.create_resource "title" => "thing3", "url" => "IMBROKE", "contact_email" => "something@gmail.com", "location" => "Global",
                                                "types" => 'BrokenURL,Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "description" => "descriptions", "approval_status" => 0


            @resource_httpsValidURL=Resource.create_resource "title" => "thing3", "url" => "https://callink.berkeley.edu/organization/hispanicengineersscientists", "contact_email" => "something@gmail.com", "location" => "Global",
                                                             "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "description" => "descriptions", "approval_status" => 0


    end


    it "should print out good URL status" do
      expect do
        @resource_goodURL1.isURLBroken_ifSoTagIt()
      end.to output("GOOD URL").to_stdout
    end


     it "should tag a resource with a broken URL" do
        @resource_badURL1.isURLBroken_ifSoTagIt()
        isURLTaggedAsBroken=false

        @resource_badURL1.reload.types.as_json.each do |type|
            print(type["val"])
           if type["val"]=="BrokenURL"
              isURLTaggedAsBroken=true
           end
        end
        expect(isURLTaggedAsBroken).to equal(true)
    end


    it "should tag a resource with a broken URL correctly but not tag it twice if it's already been tagged" do

        @resource_taggedBrokenURLAlready.isURLBroken_ifSoTagIt()
        isURLTaggedAsBroken=false
        count=0
        @resource_taggedBrokenURLAlready.reload.types.as_json.each do |type|
           if type["val"]=="BrokenURL"
              isURLTaggedAsBroken=true
              count=count+1
           end
        end

        expect(isURLTaggedAsBroken).to equal(true)
        expect(count).to equal(1)

    end

    it "not tag a resource with a valid URL" do
        @resource_goodURL1.isURLBroken_ifSoTagIt()
        isURLTaggedAsBroken=false
        count=0
        @resource_goodURL1.reload.types.as_json.each do |type|
           if type["val"]=="BrokenURL"
              isURLTaggedAsBroken=true
              count=count+1
           end
        end
        expect(isURLTaggedAsBroken).to equal(false)
        expect(count).to equal(0)
    end

    it "https url thats valid shouldn't be tagged as broken" do
      @resource_httpsValidURL.isURLBroken_ifSoTagIt()
      isURLTaggedAsBroken=false
      count=0
      @resource_httpsValidURL.reload.types.as_json.each do |type|
        if type["val"]=="BrokenURL"
          isURLTaggedAsBroken=true
          count=count+1
        end
      end
      expect(isURLTaggedAsBroken).to equal(false)
      expect(count).to equal(0)
    end




    it "call isUrlBroken for every resource in database" do

        count=0
        Resource.all.each do |resource|
            puts(resource.title)
            resource.isURLBroken_ifSoTagIt()
            count+=1
        end
        expect(count).to equal(4)
    end
  end
end
