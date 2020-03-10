class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  rescue_from Exception, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }
  end

  private

  def render_500
    render 'errors/error_500', status: :internal_server_error
  end

  def render_404
    render 'errors/error_404', status: :not_found
  end
end
