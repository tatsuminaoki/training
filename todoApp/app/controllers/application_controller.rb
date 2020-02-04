class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :is_maintenance
  before_action :set_locale
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize
    redirect_to login_path, alert: I18n.t('flash_message.not_authorized') if current_user.nil?
  end

  def after_sign_in_path_for(current_user)
    current_user.presence ? tasks_path : login_path
  end

  def authenticate_user!
    opts[:scope] = :user
    warden.authenticate!(opts) if !(is_a?(::UserController)) || opts.delete(:force)
  end

  def warden
    request.env['warden'] or raise MissingWarden
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def is_maintenance
    redirect_to under_maintenance_path if Maintenance.last&.maintenance_mode == true
  end
end
