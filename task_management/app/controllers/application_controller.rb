class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :authorize_user

  def authorize_user
    redirect_to login_path, alert: I18n.t('flash.require_log_in') if current_user.nil?
  end
end
