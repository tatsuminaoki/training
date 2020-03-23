# frozen_string_literal: true

module ErrorHandle
  extend ActiveSupport::Concern
  included do
    # rescue_from Exception, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404

    def render_500
      render 'errors/error_500', status: :internal_server_error
    end

    def render_404
      render 'errors/error_404', status: :not_found
    end
  end
end
