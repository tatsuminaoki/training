# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale
  include SessionsHelper

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  protected

  def require_login
    return if logged_in?
    flash[:error] = 'You must be logged in to access this section'
    redirect_to login_path
  end
end
