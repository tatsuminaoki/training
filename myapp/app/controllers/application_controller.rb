class ApplicationController < ActionController::Base
  unless Rails.env.development?
    rescue_from Exception, with: :rescue500
    rescue_from ActionController::RoutingError, with: :rescue404
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  end

  def rescue404
    render 'errors/not_found', status: 404
  end

  def rescue500
    render 'errors/internal_server_error', status: 500
  end
end
