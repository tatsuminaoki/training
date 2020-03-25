# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ErrorHandle

  before_action :verify_authenticity_token
  before_action :set_locale
  before_action :current_user
  before_action :require_sign_in!
  helper_method :signed_in?

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def sign_in(user)
    remember_token = UserLoginManager.create!(user_id: user.id, ip: request)
    cookies.permanent[:user_remember_token] = remember_token
    @current_user = user
  end

  def current_user
    return @current_user = nil if cookies[:user_remember_token].blank?
    @current_user ||= UserLoginManager.auth(remember_token: cookies[:user_remember_token], request: request)
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def signed_in?
    @current_user.present?
  end

  private

  def require_sign_in!
    redirect_to root_path unless signed_in?
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : :en
  end
end
