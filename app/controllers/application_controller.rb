class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :current_user
  before_action :require_sign_in
  helper_method :signed_in?, :current_user
  protect_from_forgery with: :exception

  include LoginHandler
end
