# frozen_string_literal: true
class UserMailerPreview < ActionMailer::Preview
  @@resource = Resource.new(title: 'resource1', url: 'www.website.com',
                            contact_email: 'email@gmail.com', location: 'Berkeley',
                            description: 'description')
  def existing_welcome_email
    resource_owner = ResourceOwner.new(email: 'email@email.com', password: 'abc123')
    UserMailer.with(resource_owner: resource_owner, password: 'abc123').existing_welcome_email
  end

  def broken_url_initial
    UserMailer.with(resource: @@resource).broken_url_initial
  end

  def broken_url_first_reminder
    UserMailer.with(resource: @@resource).broken_url_first_reminder
  end

  def broken_url_second_reminder
    UserMailer.with(resource: @@resource).broken_url_second_reminder
  end

  def approval_initial
    UserMailer.with(resource: @@resource).approval_initial
  end

  def approval_first_reminder
    UserMailer.with(resource: @@resource).approval_first_reminder
  end

  def approval_second_reminder
    UserMailer.with(resource: @@resource).approval_second_reminder
  end

  def expired_event_initial
    UserMailer.with(resource: @@resource).expired_date_initial
  end

  def expired_event_first
    UserMailer.with(resource: @@resource).expired_date_first_reminder
  end

  def expired_event_second
    UserMailer.with(resource: @@resource).expired_date_second_reminder
  end

  def annual_initial
    UserMailer.with(resource: @@resource).annual_initial
  end

  def annual_first
    UserMailer.with(resource: @@resource).annual_first_reminder
  end

  def annual_second
    UserMailer.with(resource: @@resource).annual_second_reminder
  end
end