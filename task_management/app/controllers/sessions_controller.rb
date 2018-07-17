class SessionsController < ApplicationController
  skip_before_action :authorize_user
  def new
    redirect_to root_path if logged_in?
  end

  def login
    user = User.find_by(user_name: params[:user_name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: I18n.t('flash.success_log_in')
    else
      redirect_to ({action: 'new'}), alert: I18n.t('flash.failure_log_in')
    end
  end

  def logout
    session.delete(:user_id)
    redirect_to login_path, notice: I18n.t('flash.success_log_out')
  end
end
