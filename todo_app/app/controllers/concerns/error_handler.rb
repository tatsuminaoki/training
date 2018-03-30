# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionView::MissingTemplate, with: :render_404
  end

  private

  def render_404
    render file: Rails.root.join('public', '404.html'), layout: false, status: :not_found, content_type: 'text/html'
  end

  def render_500
    render file: Rails.root.join('public', '500.html'), layout: false, status: :internal_server_error, content_type: 'text/html'
  end
end
