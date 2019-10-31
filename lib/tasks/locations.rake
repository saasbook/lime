namespace :locations do
  desc "TODO"
  task import: :environment do
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
      ResourceOwner.create(email: email, password: password)
    end
  end

end
