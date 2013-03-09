class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
  	I18n.locale = params[:locale] || cookies[:locale] || I18n.default_locale
    
    # Store locale in users cookie
    cookies[:locale] == I18n.locale || cookies[:locale] = I18n.locale
  end
end
