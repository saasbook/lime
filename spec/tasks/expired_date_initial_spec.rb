require 'rspec'
require 'rails_helper'
require 'rake'
Rake.application.rake_require 'tasks/scheduler'

RSpec.describe 'scheduler namespace rake task' do
  fixtures :resources
  first_time = Time.local(2019, 11, 10, 0, 0, 0)

  before :each do
    Rake::Task.define_task(:environment)
    Timecop.freeze(first_time)
  end

  after :each do
    Timecop.return
  end

  let :run_expired_event_email do
    Rake::Task['send_expired_event_email'].reenable
    Rake::Task['send_expired_event_email'].invoke
  end

  it 'should send a reminder email to resources (with a valid resource owner
      email) whose deadline has passed' do
    expect { run_expired_event_email }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should change the expired_num for the resource to 1 if we are sending
      the initial expired date email' do
    expect(Resource.find_by_title('resource0').expired_num).to eq(0)
    expect(Resource.find_by_title('resource2').expired_num).to eq(0)
    run_expired_event_email
    expect(Resource.find_by_title('resource0').expired_num).to eq(1)
    expect(Resource.find_by_title('resource2').expired_num).to eq(1)
  end

  it 'should update expired_last attribute of resource if we are sending
      the initial expired date email' do
    expect(Resource.find_by_title('resource0').expired_last).to be_nil
    expect(Resource.find_by_title('resource2').expired_last).to be_nil
    run_expired_event_email
    expect(Resource.find_by_title('resource0').expired_last).to eq first_time
    expect(Resource.find_by_title('resource2').expired_last).to eq first_time
  end
end