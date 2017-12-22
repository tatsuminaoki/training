class ApplicationController < ActionController::Base
  before_action :require_login
  protect_from_forgery with: :exception
  include LoginHelper

  def require_admin_role
    redirect_to root_path, notice: I18n.t('application.controller.messages.role_error') unless admin_role?
  end

  private def require_login
    redirect_to logins_new_path unless logged_in?
  end
end
