require 'rspec'
require 'rails_helper'
require 'support/factory_girl'

RSpec.describe ResourcesController, :type => :controller do
  describe 'Responds successfully' do
    it 'returns the right HTTP response codes' do
      get :index
      expect(response.status).to eq 200
      get :show, params: {format: :json, id: 1}
      expect(response.status).to eq 200
      post :create, params: {format: :html}
      expect(response.status). to eq 204
    end
  end

  describe 'model filter method' do
    it 'calls the model method that performs the database filtering' do
      params = ActionController::Parameters.new(  {types: "Events,Mentoring"} )
      params.permit!
      expect(Resource).to receive(:filter).with(params)
      get :index, params: {:types => 'Events,Mentoring', :sort_by => 'title'}
    end
    it 'can do a simple filter by column name' do
      Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      Resource.create_resource "title" => "thing2", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Mentoring', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      Resource.create_resource "title" => "thing3", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      Resource.create_resource "title" => "thing4", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Mentoring', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"

      result = Resource.filter({"title" => "thing3"})
      print result.pretty_print_inspect
      expect(result.count).to eq 1
      expect(result.first.title).to eq "thing3"

      get :index, params: {:types => 'Scholarship,Funding', :sort_by => 'title'}
      print response.parsed_body
    end
    it 'splits has_many associations correctly and returns the right thing' do
      # create 2 resources with Scholarship and Funding types but with an extra type as well
      Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
          "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      Resource.create_resource "title" => "thing2", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Mentoring', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      Resource.create_resource "title" => "thing3", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Funding,Mentoring', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"

      result = Resource.filter({:types=>"Scholarship,Funding"})
      print result.pretty_print_inspect
      expect(result.count).to eq 2
      expect(result.where(title: "thing1")).to exist
      expect(result.where(title: "thing2")).to exist
      expect(result.where(title: "thing3")).not_to exist
    end
  end

  describe "POST create" do
    it "receive a valid post request via create" do
      post :create, params: {title: "something", url: "something.com", contact_email: "something@gmail.com", location: "someplace", types: 'Scholarship,Funding', audiences: 'Grad,Undergrad', desc: "descriptions"}
      expect(Resource.where(title: "something")).to exist
      resource = Resource.find_by(title: "something")

      expect(resource.title).to eq "something"
      expect(resource.url).to eq "something.com"
      expect(resource.contact_email).to eq "something@gmail.com"
      expect(resource.location).to eq "someplace"
      expect(resource.audiences).to exist
      expect(resource.types).to exist
      expect(resource.desc).to eq "descriptions"
    end

    it "receive an invalid post request via create" do
      post :create, params: {title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: "descriptions"}
      post :create, params: {title: "something2",contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: '111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'}
      expect(Resource.where(title: "something")).to exist
      expect(Resource.where(title: "something2")).not_to exist
    end
  end
end
