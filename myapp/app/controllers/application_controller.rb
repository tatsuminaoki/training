class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :set_locale

  include ErrorHandle

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  private

  def render_500
    render 'errors/error_500', status: :internal_server_error
  end

  def render_404
    render 'errors/error_404', status: :not_found
  end
end
