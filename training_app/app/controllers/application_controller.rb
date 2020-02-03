# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :render_maintenance, if: -> { Admin::Maintenance.maintenance? }
  before_action :check_authenticate

  private

  def check_authenticate
    redirect_to(sign_in_path(redirect_to: request.path)) if current_user.nil?
  end

  def current_user
    return if session[:user_id].nil?
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def render_maintenance
    render plain: 'メンテ中', status: :service_unavailable
  end
end
