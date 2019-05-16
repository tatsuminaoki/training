# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale, :require_login
  add_flash_types :success, :danger

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def require_login
    return if logged_in?

    redirect_to login_path, danger: I18n.t('.flash.errors.login')
  end
end
