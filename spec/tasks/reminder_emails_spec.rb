require 'rspec'
require 'rails_helper'
require 'rake'

RSpec.describe 'reminder_emails namespace rake task' do
  fixtures :resources
  before :all do
    Rake.application.rake_require 'tasks/reminder_emails'
    Rake::Task.define_task(:environment)
    time = Time.local(2019, 11, 10, 0, 0, 0)
    Timecop.freeze(time)
  end

  after :all do
    Timecop.return
  end

  let :run_rake_task do
    Rake::Task['reminder_emails:send_annual_reminder_email'].reenable
    Rake.application.invoke_task 'reminder_emails:send_annual_reminder_email'
  end

  it 'should send a reminder email to to resources (with a valid resource owner email) that have not been updated for a year' do
    expect { run_rake_task }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end
end