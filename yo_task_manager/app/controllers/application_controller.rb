# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale
  helper_method :current_user

  def switch_locale(&action)
    locale = (params[:locale] if I18n.available_locales.include? params[:locale]&.to_sym) || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def user_is_logged_in
    flash[:danger] = [t('please_login')] unless session[:user_id]
    redirect_to login_path unless session[:user_id]
  end
end
