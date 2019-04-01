require 'rspec'
require 'rails_helper'

RSpec.describe 'Resource model methods functionality', :type => :model do
  describe 'create resource functionality' do
    it 'creates resources in the database' do
      Resource.destroy_all
      Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      Resource.create_resource "title" => "thing2", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                               "types" => 'Scholarship,Funding,Mentoring', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
      result = Resource.all.order(:title)
      puts result.inspect
      expect(result.count).to eq 2
      expect(result.first.title).to eq "thing1"
      expect(result.second.title).to eq "thing2"
    end
  end

  describe 'filter functionality' do
    Resource.destroy_all
    Resource.create_resource "title" => "thing1", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                             "types" => 'Scholarship,Funding,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
    Resource.create_resource "title" => "thing2", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                             "types" => 'Scholarship,Funding,Mentoring', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
    Resource.create_resource "title" => "thing3", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                             "types" => 'Scholarship,Events,Networking', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
    Resource.create_resource "title" => "thing4", "url" => "something.com", "contact_email" => "something@gmail.com", "location" => "someplace",
                             "types" => 'Funding,Mentoring', "audiences" => 'Grad,Undergrad', "desc" => "descriptions"
    it 'can do a simple filter by column name' do
      result = Resource.filter({"title" => "thing3"})
      print result.pretty_print_inspect
      expect(result.count).to eq 1
      expect(result.first.title).to eq "thing3"
    end

    it 'splits has_many associations correctly and returns the right thing' do
      result = Resource.filter({:types=>"Scholarship,Funding"})
      print result.pretty_print_inspect
      expect(result.count).to eq 2
      expect(result.where(title: "thing1")).to exist
      expect(result.where(title: "thing2")).to exist
      expect(result.where(title: "thing3")).not_to exist
      expect(result.where(title: "thing4")).not_to exist
    end
  end

end