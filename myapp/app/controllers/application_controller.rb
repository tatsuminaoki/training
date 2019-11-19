# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login

  helper_method :current_user

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  private

  def require_login
    redirect_to login_url unless current_user
  end
end
