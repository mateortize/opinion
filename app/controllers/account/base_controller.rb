class Account::BaseController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_account!
  layout 'account'

  before_action :set_locale
  def set_locale
    session[:opinion7_locale] = params[:locale] if !params[:locale].blank?
    I18n.locale = session[:opinion7_locale] || I18n.default_locale
    set_tab I18n.locale, :navigation
  end
end