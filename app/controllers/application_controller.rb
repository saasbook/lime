class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session


  #redirect resource owners to their resources after they sign in successfully
  def after_sign_in_path_for(resource_owner)
    if resource_owner_signed_in?
      resources_all_path
    else
      welcome_index_path
    end
  end
  
end
