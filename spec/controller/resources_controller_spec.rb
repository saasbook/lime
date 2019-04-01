require 'rspec'
require 'rails_helper'

RSpec.describe ResourcesController, :type => :controller do
  it 'responds successfully' do
    get :index
    expect(response.status).to eq 200
    get :show, params: {format: :json, id: 1}
    expect(response.status).to eq 200
  end

  describe 'filtering by query terms' do
    it 'calls the model method that performs the database filtering' do
      params = ActionController::Parameters.new(  {types: "Events,Mentoring"} )
      params.permit!
      expect(Resource).to receive(:filter).with(params)
      get :index, params: {:types => 'Events,Mentoring', :sort_by => 'title'}
    end
    it 'splits has_many associations correctly and returns the right thing' do

    end
    it '' do

    end
    it 'makes the results available to the template' do

    end
  end
end
