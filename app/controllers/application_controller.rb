class ApplicationController < ActionController::Base
  
  protect_from_forgery
  before_filter :set_locale

  def after_sign_in_path_for(resource)
    root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

    def set_locale
      I18n.locale = params[:locale] if params[:locale].present?
    end

    def default_url_options(options={})
      {locale: I18n.locale}
    end
end
