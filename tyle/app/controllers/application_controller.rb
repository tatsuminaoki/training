# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :render_maintenance_page, if: :maintenance_mode?
  before_action :current_user
  before_action :require_sign_in!
  helper_method :signed_in?

  protect_from_forgery with: :exception

  def current_user
    remember_token = User.encrypt(cookies[:user_remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:user_remember_token] = remember_token
    user.update!(remember_token: User.encrypt(remember_token))
    @current_user = user
  end

  def sign_out
    cookies.delete(:user_remember_token)
  end

  def signed_in?
    @current_user.present?
  end

  private

  def require_sign_in!
    redirect_to login_path unless signed_in?
  end

  def redirect_if_unauthorized
    return if current_user.role == 'administrator'

    redirect_to root_path
  end

  def maintenance_mode?
    File.exist?('tmp/maintenance.yml')
  end

  def render_maintenance_page
    maintenance = YAML.safe_load(File.read('tmp/maintenance.yml'))
    @period = maintenance['period']
    render 'maintenance', status: :service_unavailable
  end
end
