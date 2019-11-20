class Email
  @@valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/

  def self.valid_email?(email)
    @@valid_email_regex.match(email)
  end



end