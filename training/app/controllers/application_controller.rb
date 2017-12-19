class ApplicationController < ActionController::Base
  before_action :require_login
  protect_from_forgery with: :exception
  include LoginHelper


private
  def require_login
    redirect_to logins_new_path unless logged_in?
  end
end
