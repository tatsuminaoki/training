class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:info] = t('message.success.complete_login')
      redirect_to tasks_url
    else
      flash[:warning] = t('message.error.login')
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:info] = t('message.success.complete_logout')
    redirect_to login_url
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
