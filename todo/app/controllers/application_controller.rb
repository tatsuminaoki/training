# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale
  before_action :return_503, if: :maintenance_mode?
  include SessionsHelper

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def maintenance_mode?
    site_setting = SiteSetting.first_or_create
    site_setting.on?
  end

  def return_503
    render(file: Rails.public_path.join('503.html'),
           content_type: 'text/html',
           layout: false,
           status: :service_unavailable,
          )
  end

  protected

  def require_login
    return if logged_in?
    flash[:error] = 'You must be logged in to access this section'
    redirect_to login_path
  end
end
