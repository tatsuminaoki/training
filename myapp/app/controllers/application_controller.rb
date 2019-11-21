# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  private

  def require_login
    redirect_to login_url unless current_user
  end
end
