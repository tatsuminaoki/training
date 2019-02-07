# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  class Forbidden < ActionController::ActionControllerError; end

  #rescue_from Exception, with: :error_500
  rescue_from Forbidden, with: :error_403
  rescue_from ActionController::RoutingError, with: :error_404
  rescue_from ActiveRecord::RecordNotFound, with: :error_404

  def error_403
    render template: 'errors/error_403', status: 403, layout: 'application', content_type: 'text/html'
  end

  def error_404
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def error_500
    render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_in_path_for(*)
    root_path
  end

  def all_labels
    @labels = Label.all
  end
end
