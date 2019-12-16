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
      resource.update_column_no_timestamp(:num_emails, 2)
      resource.update_column_no_timestamp(:last_email_sent, Time.now)
    end
    Timecop.freeze(first_time + 3.week)
  end

  after :each do
    Timecop.return
  end

  let :run_annual_reminder_emails do
    Rake::Task[:send_annual_reminder_email].reenable
    Rake::Task[:send_annual_reminder_email].execute
  end

  it "should send second warning email to resources that have been sent an annual
      reminder email but have not responded in three weeks" do
    expect { run_annual_reminder_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should not update last_email_sent attribute of resource if we are sending
      the second warning email' do
    run_annual_reminder_emails
    expect(Resource.find_by_title('resource0').last_email_sent).to eq first_time
    expect(Resource.find_by_title('resource2').last_email_sent).to eq first_time
  end

  it 'should change the num_emails for the resource to 3 if we are sending
      the second warning email' do
    run_annual_reminder_emails
    expect(Resource.find_by_title('resource0').num_emails).to eq(3)
    expect(Resource.find_by_title('resource2').num_emails).to eq(3)
  end

  it 'should move the resource to the archive if a week passes after sending
      the second warning email' do
    Resource.out_of_date_resources.each do |resource|
      resource.update_column_no_timestamp(:num_emails, 3)
    end
    Timecop.freeze(first_time + 4.weeks)
    run_annual_reminder_emails
    expect(Resource.find_by_title('resource0').approval_status).to eq(2)
    expect(Resource.find_by_title('resource2').approval_status).to eq(2)
  end
end

