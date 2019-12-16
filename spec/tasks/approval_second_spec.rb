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
    resources = [Resource.first, Resource.second]
    resources.each do |resource|
      resource.update_column_no_timestamp(:approval_num, 2)
      resource.update_column_no_timestamp(:approval_status, 1)
      resource.update_column_no_timestamp(:approval_last, first_time)
    end
    Timecop.freeze(first_time + 3.weeks)
  end

  after :each do
    Timecop.return
  end

  let :run_approval_email do
    Rake::Task[:send_approval_email].reenable
    Rake::Task[:send_approval_email].invoke
  end

  it "should send the first approval reminder email to resources that have been
      sent an initial approval email but have not responded in a week" do
    expect { run_approval_email }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it 'should not update approval_last attribute of resource if we are
      sending the first warning email' do
    run_approval_email
    expect(Resource.find_by_title('resource0').approval_last).to eq first_time
    expect(Resource.find_by_title('resource1').approval_last).to eq first_time
  end

  it 'should change the approval_num for the resource to 3 if we are
      sending the first warning email' do
    run_approval_email
    expect(Resource.find_by_title('resource0').approval_num).to eq(3)
    expect(Resource.find_by_title('resource1').approval_num).to eq(3)
  end
end

