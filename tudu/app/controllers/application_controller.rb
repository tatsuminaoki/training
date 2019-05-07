class ApplicationController < ActionController::Base
  ### rescue_from Exception, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  before_action :render_maintenance!, if: :maintenance_mode?

  include ApplicationHelper
  include SessionsHelper

  def render_404
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def render_500
    render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end

  def maintenance_mode?
    file_path = Rails.root.to_s + '/maintenance.txt'
    File.exists?(file_path)
  end

  def render_maintenance!
    render(
      file: Rails.public_path.join('503.html'),
      content_type: 'text/html',
      layout: false,
      status: :service_unavailable
    )
  end

  def ensure_log_in_user!
    return true if logged_in?

    flash[:danger] = t('session.login.not_login')
    redirect_to login_url(next: redirect_location)
  end
end
