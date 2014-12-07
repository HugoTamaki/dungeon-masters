class Users::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    # custom logic
    if params[:user][:password].present?
      result = resource.update_with_password(params[resource_name])
    else
      result = resource.update_without_password(params[resource_name].permit(:about_me))
    end

    # standart devise behaviour
    if result
      if is_navigational_format?
        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
          flash_key = :update_needs_confirmation
        end
        set_flash_message :notice, flash_key || :updated
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
      devise_parameter_sanitizer.for(:sign_up) << :about_me
      devise_parameter_sanitizer.for(:account_update) << :name
      devise_parameter_sanitizer.for(:account_update) << :about_me
    end
end