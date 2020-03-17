class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  include ErrorHandle

  before_action :set_locale

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }
  end

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:user_remember_token] = remember_token
    user.update!(remember_token: User.encrypt(remember_token))
    @current_user = user
  end

  def sign_out
    cookies.delete(:user_remember_token)
  end

  private

  def render_500
    render 'errors/error_500', status: :internal_server_error
  end

  def render_404
    render 'errors/error_404', status: :not_found
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : :en
  end
end
