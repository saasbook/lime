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

  def first_warning_email
    @resource = params[:resource]
    mail(to: @resource.contact_email, subject: "First warning: Please update your resource #{@resource.title} on the Berkeley Innovations Resources Database.")
  end

  def second_warning_email
    @resource = params[:resource]
    mail(to: @resource.contact_email, subject: "Second warning: Please update your resource #{@resource.title} on the Berkeley Innovations Resources Database.")
  end

  def third_warning_email
    @resource = params[:resource]
    mail(to: @resource.contact_email, subject: "Third warning: Please update your resource #{@resource.title} on the Berkeley Innovations Resources Database.")
  end

  def expired_event_email
    @resource = params[:resource]
    mail(to: @resource.contact_email, subject: "Third warning: Please update your resource #{@resource.title} on the Berkeley Innovations Resources Database.")
  end

  def resource_approved_email
    @resource = params[:resource]
    mail(to: @resource.contact_email, subject: "Your email has been approved on the Berkeley Innovations Resource Database") unless @resource.contact_email.nil?
  end
end
