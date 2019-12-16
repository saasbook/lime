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
    Resource.out_of_date_resources.each do |resource|
      resource.update_column_no_timestamp(:expired_num, 2)
      resource.update_column_no_timestamp(:expired_last, Time.now)
    end
    Timecop.freeze(first_time + 3.weeks)
  end

  after :each do
    Timecop.return
  end

  let :run_expired_event_email do
    Rake::Task['send_expired_event_email'].reenable
    Rake::Task['send_expired_event_email'].invoke
  end

  it 'should send the expired_date_first email to resources (with a valid
      resource owner email) whose deadline has passed and has not
      responded within three weeks' do
    expect { run_expired_event_email }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should change the expired_num for the resource to 3 if we are sending
      the second expired date reminder email' do
    run_expired_event_email
    expect(Resource.find_by_title('resource0').expired_num).to eq(3)
    expect(Resource.find_by_title('resource2').expired_num).to eq(3)
  end

  it 'should update expired_last attribute of resource if we are sending
      the second expired date reminder email' do
    run_expired_event_email
    expect(Resource.find_by_title('resource0').expired_last).to eq first_time
    expect(Resource.find_by_title('resource2').expired_last).to eq first_time
  end

  it "should remove the resource's deadline if a week passes after sending
      the second expired date reminder email" do
    Resource.out_of_date_resources.each do |resource|
      resource.update_column_no_timestamp(:expired_num, 3)
    end
    Timecop.freeze(first_time + 4.weeks)
    run_expired_event_email
    expect(Resource.find_by_title('resource0').deadline).to be nil
    expect(Resource.find_by_title('resource2').deadline).to be nil
  end
end
