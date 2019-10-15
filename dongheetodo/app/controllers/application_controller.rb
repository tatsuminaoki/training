class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, AbstractController::ActionNotFound, with: :render_404
  rescue_from ActionController::InvalidAuthenticityToken, ActionController::InvalidCrossOriginRequest, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved, with: :render_422
#  rescue_from Exception, with: :render_500
  before_action :maintenance?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user
  end

  def maintenance?
    env_file = File.join(Rails.root,'config', 'local_env.yml')
    if File.exists?(env_file)
      YAML.load(File.open(env_file)).each do |k, v|
        if k.to_s == 'MAINTENANCE' && v == 'UP'
          render_503
        end
      end
    end
  end

  def render_401
    render template: "errors/error_401", layout: "error_page", status: :unauthorized, content_type: "text/html"
  end

  def render_404
    render template: "errors/error_404", layout: "error_page", status: :not_found, content_type: "text/html"
  end

  def render_422
    render template: "errors/error_422", layout: "error_page", status: :unprocessable_entity, content_type: "text/html"
  end

  def render_500
    render template: "errors/error_500", layout: "error_page", status: :internal_server_error, content_type: "text/html"
  end

  def render_503
    render template: "errors/error_503", layout: "error_page", status: :service_unavailable, content_type: "text/html"
  end
end
