# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale, :require_login
  before_action :display_maintenance_page, if: :maintenance?
  add_flash_types :success, :danger

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def require_login
    return if logged_in?

    redirect_to login_path, danger: I18n.t('.flash.errors.login')
  end

  def correct_user(user)
    return if current_user.admin? || current_user?(user)
    redirect_to root_path
  end

  def maintenance?
    File.exist? Constants::MAINTENANCE_FILE
  end

  def display_maintenance_page
    render 'errors/maintenance', layout: nil
  end
end
