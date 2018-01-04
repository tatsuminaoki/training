class ApplicationController < ActionController::Base
  before_action :require_login
  skip_before_action :require_login, only: [:routing_error]
  protect_from_forgery with: :exception
  include LoginHelper

  rescue_from Exception,                        with: :_render_500
  rescue_from ActiveRecord::RecordNotFound,     with: :_render_404
  rescue_from ActionController::RoutingError,   with: :_render_404

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def require_admin_role
    redirect_to root_path, notice: I18n.t('application.controller.messages.role_error') unless admin_role?
  end

  private

  def require_login
    redirect_to logins_new_path unless logged_in?
  end

  def _render_404(e = nil)
    Rails.logger.error "404 error: #{e.message}" if e
    render template: 'errors/error_404', status: :not_found
  end

  def _render_500(e = nil)
    Rails.logger.error "500 error: #{e.message}" if e
    render template: 'errors/error_500', status: :internal_server_error
  end
end
