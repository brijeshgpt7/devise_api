class  Api::V1::RegistrationsController <  Devise::RegistrationsController
  respond_to 'json'
  prepend_before_filter :require_no_authentication, :only => [:new, :create, :cancel]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  skip_before_action :verify_authenticity_token
  include ActionController::MimeResponds
  include ActionController::Cookies
  include ActionController::Helpers


  def create
   build_resource(sign_up_params)
   if resource.save
      if resource.active_for_authentication?
        # set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        #UserMailer
        render json: { message: "Successfully record created",status: 201 }
      else
        # set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
         render json: { message: "Record not created",status: 202 }
        # respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      render :json => resource.errors, :status => :unprocessable_entity 
    end
  end

 protected
  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
    # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name,:phone_number, :role_id) }

  end
end