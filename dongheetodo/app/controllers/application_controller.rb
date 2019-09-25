class ApplicationController < ActionController::Base
  layout "error_page"

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, AbstractController::ActionNotFound, with: :render_404
  rescue_from ActionController::InvalidAuthenticityToken, ActionController::InvalidCrossOriginRequest, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved, with: :render_422
  rescue_from Exception, with: :render_500

  def render_404
    render template: "errors/error_404", status: :not_found, content_type: "text/html"
  end

  def render_422
    render template: "errors/error_422", status: :unprocessable_entity, content_type: "text/html"
  end

  def render_500
    render template: "errors/error_500", status: :internal_server_error, content_type: "text/html"
  end
end
