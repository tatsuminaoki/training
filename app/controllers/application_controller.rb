# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Exception, with: :render_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  class Forbidden < ActionController::ActionControllerError; end

  rescue_from Forbidden, with: :render_forbidden

  add_flash_types :success, :info, :warning, :danger

  private

  def render_forbidden
    render file: "public/403.html", layout: false, status: 403
  end

  def render_not_found
    render file: 'public/404.html', layout: false, status: 404
  end

  def render_error
    render file: 'public/500.html', layout: false, status: 500
  end
end
