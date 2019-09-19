# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :redirect_if_maintenance

  def login(user)
    session[:user_id] = user.id if user.present?
  end

  def logout
    @current_user = nil
    session.delete :user_id
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

  private

  # rubocop:disable Style/IfUnlessModifier, Style/GuardClause
  def redirect_if_maintenance
    if File.exist?(Rails.root.join('tmp', 'maintenance.txt')) && params[:controller] != 'maintenances'
      redirect_to maintenance_path, status: 302
    end
  end
  # rubocop:enable Style/IfUnlessModifier, Style/GuardClause
end
