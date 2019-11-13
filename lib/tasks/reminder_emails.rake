namespace :reminder_emails do
  desc 'Send annual reminder emails to resource owners to remind them to update their resources'
  task send_annual_reminder_email: :environment do
    out_of_date_resources = Set.new
    valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/
    Resource.all.each do |resource|
      if !resource.contact_email.blank? && valid_email_regex.match(resource.contact_email) \
         && TimeDifference.between(resource.updated_at, Time.now).in_years >= 1
        out_of_date_resources.add(resource)
      end
    end

    out_of_date_resources.each do |resource|
      UserMailer.with(resource: resource).annual_reminder_email.deliver_now
    end
  end
end
