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
                               "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      Resource.create_resource "title" => "thing4", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Mentoring', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"

      get '/resources?title=thing3'
      puts response.body

      # [{"id":3,"title":"thing3","url":"something.com","contact_email":"something@gmail.com","desc":"descriptions","location":"someplace","resource_email":null,"resource_phone":null,"address":null,"contact_name":null,"contact_phone":null,"deadline":null,"notes":null,"funding_amount":null,"approval_status":null,"approved_by":null,"flagged":null,"flagged_comment":null,"created_at":"2019-04-01T05:48:22.835Z","updated_at":"2019-04-01T05:48:22.835Z",
      #   "types":[{"id":8,"resource_id":3,"val":"Scholarship","created_at":"2019-04-01T05:48:22.863Z","updated_at":"2019-04-01T05:48:22.863Z"},
      #            {"id":9,"resource_id":3,"val":"Funding","created_at":"2019-04-01T05:48:22.864Z","updated_at":"2019-04-01T05:48:22.864Z"},
      #            {"id":10,"resource_id":3,"val":"Events","created_at":"2019-04-01T05:48:22.865Z","updated_at":"2019-04-01T05:48:22.865Z"},
      #            {"id":11,"resource_id":3,"val":"Networking","created_at":"2019-04-01T05:48:22.866Z","updated_at":"2019-04-01T05:48:22.866Z"}],
      #   "audiences":[{"id":5,"resource_id":3,"val":"Grad","created_at":"2019-04-01T05:48:22.860Z","updated_at":"2019-04-01T05:48:22.860Z"},
      #                {"id":6,"resource_id":3,"val":"Undergrad","created_at":"2019-04-01T05:48:22.861Z","updated_at":"2019-04-01T05:48:22.861Z"}],
      #   "client_tags":[],"population_focuses":[],"campuses":[],"colleges":[],"availabilities":[],"innovation_stages":[],"topics":[],"technologies":[]}]
      expect(response.body)
    end
  end

  describe 'create' do
    it "receive a valid post request via create" do
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

    it "receive an invalid post request via create" do
      post '/resources?title=something&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=description'
      post '/resources?title=something2&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'

      expect(Resource.where(title: "something")).to exist
      expect(Resource.where(title: "something2")).not_to exist
    end
  end

  describe 'update' do
    it 'properly updates values for admins' do
      User.create!(:email => 'example@gmail.com', :password => 'password', :api_token => 'example')
      post '/resources?title=something&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=description'
      expect(Resource.where(title: "something")).to exist
      resource = Resource.find_by(title: "something")
      expect(resource.url).to eq "something.com"

      patch '/resources/' + resource.id.to_s + '/?url=somethingelse.com&flagged=1&api_key=example'
      resource = Resource.find_by(title: "something")
      expect(resource.url).to eq "somethingelse.com"
      expect(resource.flagged).to eq 1

      patch '/resources/' + resource.id.to_s + '/?location=anotherplace&desc=another description&flagged=1&api_key=example'
      resource = Resource.find_by(title: "something")
      expect(resource.location).to eq "anotherplace"
      expect(resource.desc).to eq "another description"

      get '/resources/' + resource.id.to_s
      assert response.body.to_s.include?('anotherplace')
      assert response.body.to_s.include?('another description')
      assert response.body.to_s.include?('somethingelse.com')
    end

    it 'lets guests flag resources' do
      post '/resources?title=something&url=something.com&contact_email=something@gmail.com&location=someplace&types=Scholarship,Funding&audiences=Grad,Undergrad&desc=description'
      expect(Resource.where(title: "something")).to exist
      resource = Resource.find_by(title: "something")
      expect(resource.url).to eq "something.com"

      patch '/resources/' + resource.id.to_s + '/?flagged=1'
      resource = Resource.find_by(title: "something")
      expect(resource.flagged).to eq 1
    end
  end
end