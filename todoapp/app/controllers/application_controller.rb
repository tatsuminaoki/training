class ApplicationController < ActionController::Base
  before_action :login_required

  unless Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from Exception, with: :render_500
  end

  def render_404
    render template: 'errors/error_404',
           status: 404,
           layout: 'application',
           content_type: 'text/html'
  end

  def render_500
    render template: 'errors/error_500',
           status: 500,
           layout: 'application',
           content_type: 'text/html'
  end

  private

  def current_user
    @current_user ||= if cookies[:user_remember_token]
                        remember_digest = User.encrypt(cookies[:user_remember_token])
                        User.find_by(remember_digest: remember_digest)
                      end
  end

  def login_required
    redirect_to login_path unless current_user
  end

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:user_remember_token] = remember_token
    user.update!(remember_digest: User.encrypt(remember_token))
  end

  def sign_out
    @current_user = nil
    cookies.delete(:user_remember_token)
  end
end
