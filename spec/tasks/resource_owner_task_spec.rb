require 'rspec'
require 'rails_helper'
require 'rake'

RSpec.describe 'resource_owner_tasks namespace rake task' do
  fixtures :resources
  before :all do
    Rake.application.rake_require 'tasks/resource_owner_tasks'
    Rake::Task.define_task(:environment)
  end

  let :run_rake_task do
    Rake::Task['resource_owner_tasks:add_resource_owners'].reenable
    Rake.application.invoke_task 'resource_owner_tasks:add_resource_owners'
  end

  it 'should add existing resource owners with valid emails to the resource owners table' do
    run_rake_task
    (0..2).each do |i|
      expect(ResourceOwner.find_by_email("email#{i}@email.com")).to_not be_nil
    end
    expect(ResourceOwner.find_by_email('email3@email.com')).to be_nil
  end

  it 'should send emails to existing resource owners with valid emails notifying that they have accounts' do
    expect { run_rake_task }.to change { ActionMailer::Base.deliveries.count }.by(3)
  end
end