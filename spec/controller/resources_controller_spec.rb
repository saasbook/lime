require 'rspec'
require 'rails_helper'

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

  describe 'model filter method is called upon GET request' do
    it 'calls the model method that performs the database filtering' do
      params = ActionController::Parameters.new(  {types: "Events,Mentoring"} )
      params.permit!
      expect(Resource).to receive(:filter).with(params)
      get :index, params: {:types => 'Events,Mentoring', :sort_by => 'title'}
    end
  end

  describe "POST create" do
    it 'calls the correct model method' do
      params = ActionController::Parameters.new({title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: "descriptions", approval_status: 0})
      params.permit!
      expect(Resource).to receive(:create_resource).with(params)
      post :create, params: {title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: "descriptions"}
    end
  end

  describe "PATCH update" do
    it 'calls the correct model method' do
      resource = Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "Global",
                               "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      User.create!(:email => 'example@gmail.com', :password => 'password', :api_token => 'example')
      params = ActionController::Parameters.new({title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: "descriptions"})
      params.permit!

      # test allowed to update
      expect(Resource).to receive(:update).with(resource.id.to_s, params)
      patch :update, params: {id: resource.id, title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: "descriptions", api_key: "example"}, :format => :json

      # test not allowed to update without valid api key
      expect(Resource).not_to receive(:update)
      patch :update, params: {id: resource.id, api_key: 'invalid', flagged: 0}, :format => :json
    end

    it "doesn't call update for guests who try to update values they are not permitted to" do
      resource = Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "Global",
                                          "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      params = ActionController::Parameters.new({title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: "descriptions"})
      params.permit!

      # test not allowed to update values
      expect(Resource).not_to receive(:update)
      patch :update, params: {id: resource.id, title: "something", url: "something.com" ,contact_email: "something@gmail.com", location: "someplace", types: 'scholarship,funding', audiences: 'grad,undergrad', desc: "descriptions"}, :format => :json

      # test not allowed to unflag
      expect(Resource).not_to receive(:update)
      patch :update, params: {id: resource.id, flagged: 0}, :format => :json

      # test not allowed to insert garbage values into flagged
      expect(Resource).not_to receive(:update)
      patch :update, params: {id: resource.id, flagged: 'asdfasdf'}, :format => :json

      # test not allowed without a valid api_key
      expect(Resource).not_to receive(:update)
      patch :update, params: {id: resource.id, api_key: 'invalid', flagged: 0}, :format => :json
    end

    it 'lets guests flag resources' do
      resource = Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "Global",
                                          "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      params = ActionController::Parameters.new({"flagged" => 1})
      params.permit!

      # test allowed to flag without api key
      expect(Resource).to receive(:update).with(resource.id.to_s, params)
      patch :update, params: {id: resource.id, flagged: 1}
    end
  end
end
