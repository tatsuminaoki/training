# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required
  before_action :render_maintenance_page, if: :maintenance?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_url unless current_user
  end

  def maintenance?
    File.exist?(MAINTENANCE_FILE_PATH)
  end

  def render_maintenance_page
    render(
        file: Rails.public_path.join('maintenance.html'),
        content_type: 'text/html',
        layout: false,
    )
  end
end
