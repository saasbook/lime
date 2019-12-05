require 'rspec'
require 'rails_helper'
require 'rake'

RSpec.describe 'scheduler namespace rake task' do
  fixtures :resources
  first_time = Time.local(2019, 11, 10, 0, 0, 0)

  before :each do
    Rake.application.rake_require 'tasks/scheduler'
    Rake::Task.define_task(:environment)
    Timecop.freeze(first_time)
  end

  after :each do
    Timecop.return
  end

  let :run_annual_reminder_emails do
    Rake::Task['send_annual_reminder_email'].reenable
    Rake.application.invoke_task 'send_annual_reminder_email'
  end

  let :run_first_warning_emails do
    Rake::Task['send_first_warning_email'].reenable
    Rake.application.invoke_task 'send_first_warning_email'
  end

  let :run_second_warning_emails do
    Rake::Task['send_second_warning_email'].reenable
    Rake.application.invoke_task 'send_second_warning_email'
  end

  let :run_third_warning_emails do
    Rake::Task['send_third_warning_email'].reenable
    Rake.application.invoke_task 'send_third_warning_email'
  end

  let :run_expired_event_emails do
    Rake::Task['send_expired_event_email'].reenable
    Rake.application.invoke_task 'send_expired_event_email'
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

  it "should send first warning email to resources that have been sent
      an annual reminder email but have not responded in a week" do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    expect { run_first_warning_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should not update last_email_sent attribute of resource if we are
      sending the first warning email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    expect(Resource.find_by_title('resource0').last_email_sent).to eq first_time
    expect(Resource.find_by_title('resource2').last_email_sent).to eq first_time
  end

  it 'should change the num_emails for the resource to 2 if we are
      sending the first warning email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    expect(Resource.find_by_title('resource0').num_emails).to eq(2)
    expect(Resource.find_by_title('resource2').num_emails).to eq(2)
  end

  it "should send second warning email to resources that have been sent an annual
      reminder email but have not responded in two weeks" do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    expect { run_second_warning_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it "should send second warning email to resources that have been sent an annual
      reminder email but have not responded in two weeks" do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    expect { run_second_warning_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should not update last_email_sent attribute of resource if we are sending
      the second warning email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    run_second_warning_emails
    expect(Resource.find_by_title('resource0').last_email_sent).to eq first_time
    expect(Resource.find_by_title('resource2').last_email_sent).to eq first_time
  end

  it 'should change the num_emails for the resource to 3 if we are sending
      the second warning email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    run_second_warning_emails
    expect(Resource.find_by_title('resource0').num_emails).to eq(3)
    expect(Resource.find_by_title('resource2').num_emails).to eq(3)
  end

  it "should send third warning email to resources that have been sent an annual
      reminder email but have not responded in a month" do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    run_second_warning_emails
    Timecop.freeze(first_time + 1.month + 1.day)
    expect { run_third_warning_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should not update last_email_sent attribute of resource if we are
      sending the third warning email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    run_second_warning_emails
    Timecop.freeze(first_time + 1.month + 1.day)
    run_third_warning_emails
    expect(Resource.find_by_title('resource0').last_email_sent).to eq first_time
    expect(Resource.find_by_title('resource2').last_email_sent).to eq first_time
  end

  it 'should change the num_emails for the resource to 4 if we are sending
      the third warning email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    run_second_warning_emails
    Timecop.freeze(first_time + 1.month + 1.day)
    run_third_warning_emails
    expect(Resource.find_by_title('resource0').num_emails).to eq(4)
    expect(Resource.find_by_title('resource2').num_emails).to eq(4)
  end

  it 'should move the resource to the archive if we are sending the
      third email' do
    run_annual_reminder_emails
    Timecop.freeze(first_time + 1.week)
    run_first_warning_emails
    Timecop.freeze(first_time + 2.weeks)
    run_second_warning_emails
    Timecop.freeze(first_time + 1.month + 1.day)
    run_third_warning_emails
    expect(Resource.find_by_title('resource0').num_emails).to eq(4)
    expect(Resource.find_by_title('resource2').num_emails).to eq(4)
    expect(Resource.find_by_title('resource0').approval_status).to eq(2)
    expect(Resource.find_by_title('resource2').approval_status).to eq(2)
  end

  it 'should send an expired event email if a resource is expired' do
    expect{ run_expired_event_emails }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should change expired_email_sent if a resource is expired
      and updated_at should stay the same' do
    resource0_updated_at = Resource.find_by_title('resource0').updated_at
    resource2_updated_at = Resource.find_by_title('resource2').updated_at
    expect(Resource.find_by_title('resource0').expired_email_sent).to be_falsey
    expect(Resource.find_by_title('resource2').expired_email_sent).to be_falsey
    run_expired_event_emails
    expect(Resource.find_by_title('resource0').expired_email_sent).to be_truthy
    expect(Resource.find_by_title('resource2').expired_email_sent).to be_truthy
    expect(Resource.find_by_title('resource0').updated_at).to eq resource0_updated_at
    expect(Resource.find_by_title('resource2').updated_at).to eq resource2_updated_at
  end
end