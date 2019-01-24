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
    # TODO: あとでログインできるようにするよ
    user = User.find_by(email: 'aaaa@gmail.com')
    if user
      return @current_user = user
    end

    params = {
        email: 'aaaa@gmail.com',
        encrypted_password: 'aaa',
        name: 'aaa',
        group_id: nil,
        role: 1
    }
    user = User.new(params)
    user.save!

    @current_user = user
  end

  def login_required
    redirect_to login_path unless current_user
  end
end
