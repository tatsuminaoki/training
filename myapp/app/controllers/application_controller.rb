class ApplicationController < ActionController::Base
  include LoginHandler

  before_action :current_user
  before_action :require_sign_in!
  helper_method :signed_in?

  protect_from_forgery with: :exception
end
