class ApplicationController < ActionController::Base
  before_action :indicate_maintenance_display_dualing_maintenance, if: :use_before_action?
  before_action :set_current_user

  protect_from_forgery with: :exception
  include SessionsHelper

  def indicate_maintenance_display_dualing_maintenance
    if Maintenance.last.maintenance_enum == 'start'
      redirect_to maintenances_path
    end
  end

  def use_before_action?
    true
  end

  def set_current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
