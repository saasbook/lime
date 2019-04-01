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

end