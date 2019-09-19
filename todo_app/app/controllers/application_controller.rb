# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def login(user)
    session[:user_id] = user.id if user.present?
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end
end
