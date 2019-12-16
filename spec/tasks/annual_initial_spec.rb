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

  let :run_annual_reminder_emails do
    Rake::Task['send_annual_reminder_email'].reenable
    Rake::Task['send_annual_reminder_email'].invoke
  end

  let :run_expired_event_emails do
    Rake::Task['send_expired_event_email'].reenable
    Rake::Task['send_expired_event_email'].invoke
  end

  it 'should send a reminder email to to resources (with a valid resource owner email)
      that have not been updated for a year' do
    expect { run_annual_reminder_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should change the num_emails for the resource to 1 if we are sending
      the first annual email' do
    expect(Resource.find_by_title('resource0').num_emails).to eq(0)
    expect(Resource.find_by_title('resource2').num_emails).to eq(0)
    run_annual_reminder_emails
    expect(Resource.find_by_title('resource0').num_emails).to eq(1)
    expect(Resource.find_by_title('resource2').num_emails).to eq(1)
  end

  it 'should update last_email_sent attribute of resource if we are sending
      the first annual email' do
    expect(Resource.find_by_title('resource0').last_email_sent).to be_nil
    expect(Resource.find_by_title('resource2').last_email_sent).to be_nil
    run_annual_reminder_emails
    expect(Resource.find_by_title('resource0').last_email_sent).to eq first_time
    expect(Resource.find_by_title('resource2').last_email_sent).to eq first_time
  end
end