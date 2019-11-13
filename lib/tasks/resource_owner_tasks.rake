namespace :resource_owner_tasks do
  desc 'Add existing resource owners with valid emails to the Resource Owners table so that they have accounts'
  task add_resource_owners: :environment do
    valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/

    valid_emails = Set.new
    Resource.all.each do |resource|
      if !resource.resource_email.blank? && valid_email_regex.match(resource.resource_email)
        valid_emails.add(resource.resource_email)
      end
    end

    ResourceOwner.all.each do |owner|
      puts owner
    end

    valid_emails.each do |email|
      password = Devise.friendly_token(20)
      @resource_owner = ResourceOwner.create(email: email, password: password)
      UserMailer.with(resource_owner: @resource_owner, password: password).existing_welcome_email.deliver_now
    end
  end

end
