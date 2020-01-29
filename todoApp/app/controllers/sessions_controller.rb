class SessionsController < ApplicationController

  def index
    redirect_to tasks_path
  end

  def new
    redirect_to tasks_path unless current_user.nil?
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: I18n.t('flash_message.login_complete')
    else
      flash[:notice] = I18n.t('flash_message.login_error')
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: I18n.t('flash_message.logout_complete')
  end
end
