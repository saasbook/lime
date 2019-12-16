desc 'Add existing resource owners with valid emails to
      the Resource Owners table so that they have accounts'
task add_resource_owners: :environment do
  valid_emails = Set.new
  Resource.all.each do |resource|
    email = resource.contact_email
    valid_emails.add(email) if !email.blank? && Email.valid_email?(email)
  end

  valid_emails.each do |email|
    password = Devise.friendly_token(20)
    @resource_owner = ResourceOwner.create(email: email, password: password)
    UserMailer.with(resource_owner: @resource_owner, password: password).existing_welcome_email.deliver_now
  end
end