class ApplicationController < ActionController::Base
  # before_action :current_user
  # before_action :user_logged_in?
  before_action :set_current_user

  protect_from_forgery with: :exception
  include SessionsHelper

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  # def user_logged_in?
  #   if session[:user_id]
  #     begin
  #       @current_user = User.find_by(user_id: session[:user_id])
  #     rescue ActiveRecord::RecordNotFound
  #       reset_user_session
  #     end
  #   end
  #   return if @current_user
  #   flash[:referer] = request.fullpath
  #   redirect_to login_index_path
  # end

  # def current_user
  #   remember_token = User.encrypt(cookies[:user_remember_token])
  #   @current_user ||= User.find_by(remember_token: remember_token)
  # end
  # private

  # def require_sign_in!
  #   redirect_to login_path unless signed_in?
  # end
end
