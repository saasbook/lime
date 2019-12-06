# frozen_string_literal: true
desc 'Send annual reminder emails to resource owners to remind them
      to update their resources'
task send_annual_reminder_email: :environment do
  out_of_date_resources = Resource.out_of_date_resources
  out_of_date_resources.each do |resource|
    if resource.num_emails.zero?
      UserMailer.with(resource: resource).annual_initial.deliver_now
      resource.update_column_no_timestamp(:num_emails, 1)
      resource.update_column_no_timestamp(:last_email_sent, Time.now)
    elsif resource.num_emails == 1 && resource.num_weeks_passed_column?('last_email_sent', 1)
      UserMailer.with(resource: resource).annual_first_reminder.deliver_now
      resource.update_column_no_timestamp(:num_emails, 2)
    elsif resource.num_emails == 2 && resource.num_weeks_passed_column?('last_email_sent', 3)
      UserMailer.with(resource: resource).annual_second_reminder.deliver_now
      resource.update_column_no_timestamp(:num_emails, 3)
    elsif resource.num_emails == 3 && resource.num_weeks_passed_column?('last_email_sent', 4)
      resource.update_column_no_timestamp(:approval_status, 2) # move it into the archive
    end
  end
end

desc 'Send expired event email to resource owners to remind
      them to update their resources'
task send_expired_event_email: :environment do
  expired_resources = Resource.expired_resources
  expired_resources.each do |resource|
    if resource.expired_num.zero?
      UserMailer.with(resource: resource).expired_date_initial.deliver_now
      resource.update_column_no_timestamp(:expired_num, 1)
      resource.update_column_no_timestamp(:expired_last, Time.now)
    elsif resource.expired_num == 1 && resource.num_weeks_passed_column?('expired_last', 1)
      UserMailer.with(resource: resource).expired_date_first_reminder.deliver_now
      resource.update_column_no_timestamp(:expired_num, 2)
    elsif resource.expired_num == 2 && resource.num_weeks_passed_column?('expired_last', 3)
      UserMailer.with(resource: resource).expired_date_second_reminder.deliver_now
      resource.update_column_no_timestamp(:expired_num, 3)
    elsif resource.expired_num == 3 && resource.num_weeks_passed_column?('expired_last', 4)
      resource.update_column_no_timestamp(:deadline, nil)
    end
  end
end

desc 'Send approval reminder emails to resource owners to remind
      them to check if everything looks right'
task send_approval_email: :environment do
  approved_resources_sent = Resource.approved_resources_email_sent
  approved_resources_sent.each do |resource|
    if resource.approval_num == 1 && resource.num_weeks_passed_column?('approval_last', 1)
      UserMailer.with(resource: resource).approval_first_reminder.deliver_now
      resource.update_column_no_timestamp(:approval_num, 2)
    elsif resource.approval_num == 2 && resource.num_weeks_passed_column?('approval_last', 3)
      UserMailer.with(resource: resource).approval_second_reminder.deliver_now
      resource.update_column_no_timestamp(:approval_num, 3)
    end
  end
end
