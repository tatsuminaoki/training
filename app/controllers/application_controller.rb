# frozen_string_literal: true

class ApplicationController < ActionController::Base

  rescue_from Exception, with: :render_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render file: "public/404.html", layout: false, status: 404
  end

  def render_error(e)
    pp '#'*100
    pp e
    render file: "public/500.html", layout: false, status: 500
  end
end
