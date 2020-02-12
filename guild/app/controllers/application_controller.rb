# frozen_string_literal: true

class ApplicationController < ActionController::Base
  require 'logic_maintenance'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_maintenance
  before_action :session_timeout?

  def check_maintenance
    redirect_to controller: :maintenance, action: :index if !maintenance_page? && LogicMaintenance.doing?
  end

  def session_timeout?
    if !login_page? && !maintenance_page?
      redirect_to controller: :user, action: :login_top if session[:me].blank?
    end
  end

  private

  def maintenance_page?
    controller_name == 'maintenance'
  end

  def login_page?
    controller_name == 'user' && (action_name == 'login_top' || action_name == 'login')
  end
end
