class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  rescue_from Exception,                        with: :render_500
  rescue_from ActiveRecord::RecordNotFound,     with: :render_404
  rescue_from ActionController::RoutingError,   with: :render_404

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    render 'errors/error_404', status: :not_found
  end

  def render_500
    render 'errors/error_500', status: :internal_server_error
  end
end
