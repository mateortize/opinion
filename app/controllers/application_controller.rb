class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale
  before_filter :get_referrer_code

  def get_referrer_code
    session[:referrer_code] = params[:referrer_code] if params[:referrer_code]
  end

  def set_locale
    I18n.locale = params[:locale] || http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
  end

  def current_ability
    @current_ability ||= Ability.new(current_account)
  end

end
