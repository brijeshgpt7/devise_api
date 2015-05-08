# class Api::V1::SessionsController < Devise::SessionsController
#   prepend_before_filter :require_no_authentication, :only => [:create ]
#   skip_before_filter :verify_signed_out_user


#   def create
#    debugger
#    super 
#    debugger
#    #  self.resource = warden.authenticate!(auth_options)
#    #  set_flash_message(:notice, :signed_in) if is_flashing_format?
#    #  sign_in(resource_name, resource)
#    #  yield resource if block_given?
#    #  respond_with resource, location: after_sign_in_path_for(resource)
#    render json: {message: 'sucess'}
#   end
# end


class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged in" }
                      #,:data => { :auth_token => current_user.authentication_token }
  end

  def destroy
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    current_user.update_column(:authentication_token, nil)
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end
end