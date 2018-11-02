class ApplicationController < ActionController::Base
  before_action :check_session
  rescue_from ActionController::RoutingError, with: :error_404
  rescue_from Exception, with: :error_500

  include CommonLogin
  include LoginHelper

  def error_404
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def error_500
    render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end

  private

  def check_session
    return redirect_to(:controller => 'login',:action => 'index') unless logged_in?
  end
end
