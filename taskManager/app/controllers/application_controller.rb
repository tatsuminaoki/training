class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, with: :error_404
  rescue_from Exception, with: :error_500

  def error_404
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def error_500
    render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end
end
