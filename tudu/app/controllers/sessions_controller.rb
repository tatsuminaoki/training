class SessionsController < ApplicationController
  def new
    redirect_to root_url if logged_in?

    @next = next_params[:next]
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      log_in(user)
      redirect_to(params[:next] || root_url)
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

  private

  def next_params
    params.permit(
      :next
    )
  end
end
