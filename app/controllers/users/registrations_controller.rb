# frozen_string_literal: true
require 'digest'
require 'securerandom'

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    # reg_key = temp = Digest::SHA256.hexdigest <access key in db> + SecureRandom.hex
    hashed_key = Digest::SHA256.hexdigest sign_up_params[:registration_key]
    # compare with registration key stored in the database
    if (hashed_key == Key.where(:id => 1).first.registration_key)
      new_sign_up_params = {
        "email" => sign_up_params[:email],
        "password" => sign_up_params[:password],
        "password_confirmation" => sign_up_params[:password_confirmation]
      }
      sign_up_params = new_sign_up_params

        #begin super
        build_resource(sign_up_params)

        resource.save
        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
        #end super

    else
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
      
    end

    @user = current_user
    if not @user.nil?
      temp = Digest::SHA256.hexdigest @user.email + SecureRandom.hex
      @user.api_token = temp[0, temp.size / 2]
      @user.save!
    end
  end

  def showkey
    @user = current_user
    if (not @user.nil?) and request.format.html?
      flash[:notice] = "Your API key is '#{@user.api_token}'."
    end
    redirect_to "/users/edit"
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:registration_key, :api_token])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    flash[:alert] = "Invalid registration key. Your registration key is provided by a website Admin."
    new_user_registration_path
  end
end
