class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :authorize_user
  skip_before_action :authorize_user, only: [:routing_error]

  def authorize_user
    redirect_to login_path, alert: I18n.t('flash.require_log_in') if current_user.nil?
  end

  unless Rails.env.development?
    rescue_from Exception, with: :_render_500
    rescue_from ActiveRecord::RecordNotFound, with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def _render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '404 error' }, status: :not_found
    else
      render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'

    end
  end

  def render_500(e = nil)
    logger.error "Rendering 500 with exception: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '500 error'}, status: :internal_server_error
    else
      render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
    end
  end
end
