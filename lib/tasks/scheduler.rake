# frozen_string_literal: true
desc 'Send annual reminder emails to resource owners to remind them
      to update their resources'
task send_annual_reminder_email: :environment do
  out_of_date_resources = Resource.out_of_date_resources
  out_of_date_resources.each do |resource|
    next unless resource.num_emails.zero?

    UserMailer.with(resource: resource).annual_reminder_email.deliver_now
    resource.update_num_emails_and_last_email_sent(1)
  end
end

desc 'Send first reminder email to resource owners to remind
      them to update their resources'
task send_first_warning_email: :environment do
  out_of_date_resources = Resource.out_of_date_resources
  out_of_date_resources.each do |resource|
    next unless resource.num_emails == 1 && resource.one_week_passed?

    UserMailer.with(resource: resource).first_warning_email.deliver_now
    resource.update_num_emails(2)
  end
end

desc 'Send second reminder email to resource owners to
      remind them to update their resources'
task send_second_warning_email: :environment do
  out_of_date_resources = Resource.out_of_date_resources
  out_of_date_resources.each do |resource|
    next unless resource.num_emails == 2 && resource.two_weeks_passed?

    UserMailer.with(resource: resource).second_warning_email.deliver_now
    resource.update_num_emails(3)
  end
end

desc 'Send third reminder email to resource owners to remind them
      to update their resources. Also moves the resource to the archive.'
task send_third_warning_email: :environment do
  out_of_date_resources = Resource.out_of_date_resources
  out_of_date_resources.each do |resource|
    next unless resource.num_emails == 3 && resource.one_month_passed?

    UserMailer.with(resource: resource).third_warning_email.deliver_now
    resource.update_num_emails(4)
    resource.update_approval_status(2)
  end
end

desc 'Send expired event email to resource owners to remind
      them to update their resources'
task send_expired_event_email: :environment do
  expired_resources = Resource.expired_resources
  expired_resources.each do |resource|
    unless resource.expired_email_sent
      UserMailer.with(resource: resource).expired_event_email.deliver_now
      resource.update_expired_email_sent(true)
    end
  end
end
