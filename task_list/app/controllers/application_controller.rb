class ApplicationController < ActionController::Base
  before_action :indicate_maintenance_display_duaring_maintenance, unless: :maintenance_controller?
  before_action :set_current_user

  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def maintenance_controller?
    self.controller_name == 'maintenances'
  end

  def indicate_maintenance_display_duaring_maintenance
    if Maintenance.last&.is_maintenance == 'start'
      redirect_to maintenances_path
    end
  end

  def set_current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
