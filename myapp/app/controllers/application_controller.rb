class ApplicationController < ActionController::Base
  include LoginHandler

  before_action :render_maintenance_page, if: :maintenance_mode?
  before_action :current_user
  before_action :require_sign_in!
  helper_method :signed_in?

  protect_from_forgery with: :exception

  def maintenance_mode?
    File.exist?('tmp/maintenance.txt')
  end

  def render_maintenance_page
    render file: Rails.public_path.join('503.html'), layout: false, status: :service_unavailable
  end
end
