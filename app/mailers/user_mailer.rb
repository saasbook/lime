class UserMailer < ApplicationMailer
  default from: 'berkeleyinnovationresources@gmail.com'

  # def welcome_email
  #   @user = params[:user]
  #   mail(to: @user.email, subject: 'Thanks for registering on the Berkeley Innovation Resources website!')
  # end

  def existing_welcome_email
    @resource_owner = params[:resource_owner]
    @password = params[:password]
    @email = @resource_owner.email
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource_owner.email, subject: 'Congrats on inclusion in the Innovation Resources Database – please review')
  end

  def annual_initial
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'ACTION: Annual update of your listing in the Innovation Resources Database')
  end

  def annual_first_reminder
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'REMINDER: Annual update of your listing in the Innovation Resources Database')
  end

  def annual_second_reminder
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'FINAL REMINDER: Annual update of your listing in the Innovation Resources Database')
  end

  def expired_date_initial
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'Innovation Resources Database – please update your deadline')
  end

  def expired_date_first_reminder
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'Innovation Resources Database – reminder to update your deadline')
  end

  def expired_date_second_reminder
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'Innovation Resources Database – final reminder to update your deadline')
  end

  def broken_url_initial
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'Innovation Resources Database – please review your listing')
  end

  def broken_url_first_reminder
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'Innovation Resources Database – reminder to review your listing')
  end

  def broken_url_second_reminder
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'Innovation Resources Database – final reminder to review your listing')
  end

  def approval_initial
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    @email = @resource.contact_email
    @password = Devise.friendly_token(20)
    @resource_owner = ResourceOwner.create(email: @email, password: @password)
    mail(to: @resource.contact_email, subject: 'Congrats on inclusion in the Innovation Resources Database – please review')
  end

  def approval_first_reminder
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'Congrats on inclusion in the Innovation Resources Database – reminder to review')
  end

  def approval_second_reminder
    @resource = params[:resource]
    @resource_edit = Rails.configuration.action_mailer.default_url_options[:host] + '/resource_owners/sign_in'
    mail(to: @resource.contact_email, subject: 'Congrats on inclusion in the Innovation Resources Database – review opp')
  end
end
