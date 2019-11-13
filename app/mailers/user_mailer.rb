class UserMailer < ApplicationMailer
  default from: 'berkeleyinnovationresources@gmail.com'

  # def welcome_email
  #   @user = params[:user]
  #   mail(to: @user.email, subject: 'Thanks for registering on the Berkeley Innovation Resources website!')
  # end

  def existing_welcome_email
    @resource_owner = params[:resource_owner]
    @password = params[:password]
    mail(to: @resource_owner.email, subject: 'Thank you for registering on the Berkeley Innovation Resources Database!')
  end

  def annual_reminder_email
    @resource = params[:resource]
    mail(to: @resource.contact_email, subject: "Please update your resource #{@resource.title} on the Berkeley Innovations Resources Database.")
  end
end
