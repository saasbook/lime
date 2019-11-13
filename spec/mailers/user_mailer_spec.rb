require 'rspec'
require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  # Inspired by code at https://www.lucascaton.com.br/2010/10/25/how-to-test-mailers-in-rails-with-rspec/
  describe 'UserMailer' do
    describe 'existing resource owner' do
      let(:resource_owner) { instance_double 'ResourceOwner', email: 'testemail@email.com', password: 'testpassword'}
      let(:mail) { UserMailer.with(resource_owner: resource_owner).existing_welcome_email.deliver_now }
      it 'renders the subject' do
        expect(mail.subject).to eq('Thank you for registering on the Berkeley Innovation Resources Database!')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([resource_owner.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['berkeleyinnovationresources@gmail.com'])
      end

      it 'renders the right text in the email' do
        expect(mail.body.encoded).to include('You are an existing user in our database.')
      end
    end

    describe 'annual reminder email' do
      let(:resource) { instance_double 'Resource', resource_email: 'testemail@email.com', title: 'TestResource'}
      let(:mail) { UserMailer.with(resource: resource).annual_reminder_email.deliver_now }

      it 'renders the subject' do
        expect(mail.subject).to eq("Please update your resource #{resource.title} on the Berkeley Innovations Resources Database.")
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([resource.resource_email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['berkeleyinnovationresources@gmail.com'])
      end

      it 'renders the right text in the email' do
        expect(mail.body.encoded).to include("You have not updated your resource #{resource.title}")
      end
    end
  end
end