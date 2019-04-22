class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to root_url
    end
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      log_in(user)
      redirect_back_or(root_path)
    else
      flash.now[:danger] = t('session.login.failed')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = t('session.logout.success')
    redirect_to login_path
  end
end
