class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to tasks_url, notice: t('message.task.complete_login')
    else
      flash.now.alert = t('message.error.login')
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_url, notice: t('message.task.complete_logout')
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
