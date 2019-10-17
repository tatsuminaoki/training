# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :render_maintenance_page, if: :maintenance_mode?
  around_action :switch_locale
  helper_method :current_user

  def maintenance_mode?
    File.exist?('tmp/maintenance.yml')
  end

  def render_maintenance_page
    maintenance = YAML.load(File.read('tmp/maintenance.yml'))
    @reason = maintenance['reason']
    render 'errors/unavailable', layout: false, status: :service_unavailable
  end

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

  def user_is_admin
    flash[:danger] = [t('not_admin')] unless current_user.admin?
    redirect_to root_path unless current_user.admin?
  end
end
