# frozen_string_literal: true

module SessionsHelper
  def log_in(id)
    session[:user_id] = id if id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: stored_user_id)
  end

  def logged_in?
    current_user.present?
  end

  private

  def stored_user_id
    session[:user_id]
  end
end
