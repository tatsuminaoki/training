class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(user_name: params[:user_name])
    if user && user.authenticate(params[:password])
      log_in user
      redirect_to root_path, notice: I18n.t('flash.success_log_in')
    else
      redirect_to ({action: 'new'}), alert: I18n.t('flash.failure_log_in')
    end
  end

  def delete
    log_out
    redirect_to login_path, notice: I18n.t('flash.success_log_out')
  end
end
