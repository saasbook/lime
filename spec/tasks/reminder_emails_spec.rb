require 'rspec'
require 'rails_helper'
require 'rake'

RSpec.describe 'reminder_emails namespace rake task' do
  fixtures :resources
  first_time = Time.local(2019, 11, 10, 0, 0, 0)

  before :each do
    Rake.application.rake_require 'tasks/reminder_emails'
    Rake::Task.define_task(:environment)
    Timecop.freeze(first_time)
  end

  after :each do
    Timecop.return
  end

  let :run_annual_reminder_emails do
    Rake::Task['reminder_emails:send_annual_reminder_email'].reenable
    Rake.application.invoke_task 'reminder_emails:send_annual_reminder_email'
  end

  let :run_first_warning_emails do
    Rake::Task['reminder_emails:send_first_warning_email'].reenable
    Rake.application.invoke_task 'reminder_emails:send_first_warning_email'
  end

  let :run_second_warning_emails do
    Rake::Task['reminder_emails:send_second_warning_email'].reenable
    Rake.application.invoke_task 'reminder_emails:send_second_warning_email'
  end

  let :run_third_warning_emails do
    Rake::Task['reminder_emails:send_third_warning_email'].reenable
    Rake.application.invoke_task 'reminder_emails:send_third_warning_email'
  end

  it 'should send a reminder email to to resources (with a valid resource owner email) that have not been updated for a year' do
    expect { run_annual_reminder_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should change the num_emails for the resource to 1 if we are sending the first annual email' do
    expect(Resource.find_by_title('resource0').num_emails).to eq(0)
    expect(Resource.find_by_title('resource2').num_emails).to eq(0)
    run_annual_reminder_emails
    expect(Resource.find_by_title('resource0').num_emails).to eq(1)
    expect(Resource.find_by_title('resource2').num_emails).to eq(1)
  end

  it 'should update last_email_sent attribute of resource if we are sending the first annual email' do
    expect(Resource.find_by_title('resource0').last_email_sent).to be_nil
    expect(Resource.find_by_title('resource2').last_email_sent).to be_nil
    run_annual_reminder_emails
    expect(Resource.find_by_title('resource0').last_email_sent).to eq first_time
    expect(Resource.find_by_title('resource2').last_email_sent).to eq first_time
  end

  it "should send first warning email to resources that have been sent an annual reminder email but have not responded in a week" do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    expect { run_first_warning_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should not update last_email_sent attribute of resource if we are sending the first warning email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    expect(Resource.find_by_title('resource0').last_email_sent).to eq first_time
    expect(Resource.find_by_title('resource2').last_email_sent).to eq first_time
  end

  it 'should change the num_emails for the resource to 2 if we are sending the first warning email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    expect(Resource.find_by_title('resource0').num_emails).to eq(2)
    expect(Resource.find_by_title('resource2').num_emails).to eq(2)
  end

  it "should send second warning email to resources that have been sent an annual reminder email but have not responded in two weeks" do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    expect { run_second_warning_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it "should send second warning email to resources that have been sent an annual reminder email but have not responded in two weeks" do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    expect { run_second_warning_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should not update last_email_sent attribute of resource if we are sending the second warning email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    run_second_warning_emails
    expect(Resource.find_by_title('resource0').last_email_sent).to eq first_time
    expect(Resource.find_by_title('resource2').last_email_sent).to eq first_time
  end

  it 'should change the num_emails for the resource to 3 if we are sending the second warning email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    run_second_warning_emails
    expect(Resource.find_by_title('resource0').num_emails).to eq(3)
    expect(Resource.find_by_title('resource2').num_emails).to eq(3)
  end

  it "should send second warning email to resources that have been sent an annual reminder email but have not responded in a month" do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    run_second_warning_emails
    Timecop.freeze(first_time + 1.month + 1.day)
    expect { run_third_warning_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end
end