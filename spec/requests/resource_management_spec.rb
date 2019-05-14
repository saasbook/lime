require 'rspec'
require 'rails_helper'

RSpec.describe 'Resource management', :type => :request do

  describe 'index' do
    it 'renders json given normal parameters' do
      Resource.destroy_all
      Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      Resource.create_resource "title" => "thing2", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Mentoring', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      Resource.create_resource "title" => "thing3", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions", "approval_status" => '1'
      Resource.create_resource "title" => "thing4", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Mentoring', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"

      get '/resources?title=thing3'
      assert (response.body).to_s.include?('something.com')
      assert (response.body).to_s.include?('thing3')
      assert (response.body).to_s.include?('something@gmail.com')

      get '/resources?types=Events'
      assert (response.body).to_s.include?('thing3')
    end
  end

  describe 'create' do
    before(:each) do
      User.delete_all
      User.create!(:email => 'example@gmail.com', :password => 'password', :api_token => 'example')
    end

    it "adds resources to the database given valid parameters in a post request" do
      post '/resources?title=something&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=description'
      expect(Resource.where(title: "something")).to exist
      resource = Resource.find_by(title: "something")

      expect(resource.title).to eq "something"
      expect(resource.url).to eq "something.com"
      expect(resource.contact_email).to eq "something@gmail.com"
      expect(resource.location).to eq "someplace"
      expect(resource.audiences).to exist
      expect(resource.types).to exist
      expect(resource.desc).to eq "description"
      expect(resource.approval_status).to eq 0
    end

    it "doesn't add a resource to the database given invalid parameters in a post request" do
      post '/resources?title=something&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=description'
      post '/resources?title=something2&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
      expect(Resource.where(title: "something")).to exist
      expect(Resource.where(title: "something2")).not_to exist
    end

    it "adds an approved resource to the database if requester is an admin" do
      post '/resources?title=something&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=description&api_key=example'
      expect(Resource.where(title: "something")).to exist
      resource = Resource.find_by(title: "something")
      expect(resource.title).to eq "something"
      expect(resource.url).to eq "something.com"
      expect(resource.contact_email).to eq "something@gmail.com"
      expect(resource.location).to eq "someplace"
      expect(resource.audiences).to exist
      expect(resource.types).to exist
      expect(resource.desc).to eq "description"
      expect(resource.approval_status).to eq 1
    end
  end

  describe 'update' do
    before(:each) do
      User.delete_all
      User.create!(:email => 'example@gmail.com', :password => 'password', :api_token => 'example')
    end

    it 'properly updates values for admins' do
      post '/resources?title=something&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=description&client_tags=BearX'
      expect(Resource.where(title: "something")).to exist
      expect(User.where(api_token: "example")).to exist

      resource = Resource.find_by(title: "something")
      expect(resource.url).to eq "something.com"
      expect(resource.location).to eq 'someplace'
      expect(resource.types.collect(&:val)).to eq ['Scholarship', 'Funding']
      expect(resource.client_tags.collect(&:val)).to eq ['BearX']

      # patch as admin changes values
      patch '/resources/' + resource.id.to_s + '/?url=somethingelse.com&flagged=1&api_key=example&client_tags=WITI,CITRIS&location=anotherplace&desc=another description'
      resource = Resource.find_by(title: "something")
      expect(resource.url).to eq "somethingelse.com"
      expect(resource.flagged).to eq 1
      expect(resource.location).to eq "anotherplace"
      expect(resource.desc).to eq "another description"
      expect(resource.client_tags.collect(&:val)).to eq ['WITI','CITRIS']

      # make sure change is reflected in future HTTP request
      get '/resources/' + resource.id.to_s + '/?api_key=example'
      assert response.body.to_s.include?('anotherplace')
      assert response.body.to_s.include?('another description')
      assert response.body.to_s.include?('somethingelse.com')
      assert response.body.to_s.include?('WITI')

      # make sure this doesn't clear the rest of the values
      patch '/resources/' + resource.id.to_s + '/?client_tags=BearX&api_key=example'
      resource = Resource.find_by(title: "something")
      expect(resource.url).to eq "somethingelse.com"
      expect(resource.flagged).to eq 1
      expect(resource.location).to eq "anotherplace"
      expect(resource.desc).to eq "another description"
      expect(resource.client_tags.collect(&:val)).to eq ['BearX']

      # make sure change is reflected in future HTTP request
      get '/resources/' + resource.id.to_s + '?api_key=example'
      assert response.body.to_s.include?('anotherplace')
      assert response.body.to_s.include?('another description')
      assert response.body.to_s.include?('somethingelse.com')
      assert response.body.to_s.include?('BearX')
    end

    it 'properly adds to edit table' do
      post '/resources?title=something&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=description'
      resource = Resource.find_by(title: "something")
      patch '/resources/' + resource.id.to_s + '/?location=anotherplace&desc=another description&flagged=1&approval_status=1&title=blasd&url=weqweqwe.com&contact_email=ssds&api_key=example'
      expect(Edit.all.count).to eq 6
    end

    it "doesn't let guests update values they are not allowed to" do
      # seed with a resource
      expect(Resource.where(title: "something")).not_to exist
      post '/resources?title=something&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=description'
      expect(Resource.where(title: "something")).to exist
      resource = Resource.find_by(title: "something")

      # patch as guest does nothing
      patch '/resources/' + resource.id.to_s + '/?url=guest.com&description=guestupdatedescription&contact_email=guest@gmail.com&location=anotherplace&types=Networking&audiences=Grad'
      expect(Resource.where(title: "something")).to exist
      resource = Resource.find_by(title: "something")
      expect(resource.url).to eq "something.com"
      expect(resource.desc).to eq "description"
      expect(resource.contact_email).to eq "something@gmail.com"
      expect(resource.location).to eq "someplace"
      expect(resource.types.collect(&:val)).to eq ['Scholarship','Funding']
      expect(resource.audiences.collect(&:val)).to eq ["Grad","Undergrad"]

      # make sure no changes are reflected in http request
      get '/resources/' + resource.id.to_s + '/?api_key=example'
      expect(User.where(api_token: 'example')).to exist
      assert response.body.to_s.include?('something.com')
      assert response.body.to_s.include?('description')
      assert !response.body.to_s.include?('guest.com')
      assert !response.body.to_s.include?('guestupdatedescription')
    end

    it 'lets guests flag resources' do
      # seed with a resource
      post '/resources?title=something&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=description'
      expect(Resource.where(title: "something")).to exist
      resource = Resource.find_by(title: "something")
      expect(resource.url).to eq "something.com"

      # flag as guest is allowed
      patch '/resources/' + resource.id.to_s + '/?flagged=1'
      resource = Resource.find_by(title: "something")
      expect(resource.flagged).to eq 1
    end
  end
end