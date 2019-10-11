class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(login_id: params[:login_id])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = [t('.logged_in')]
      redirect_to root_url
    else
      flash.now[:danger] = [t('.log_in_failed')]
      render :new
    end
  end

  def destroy
    session[:user_id]  = nil
    flash[:success] = [t('.logged_out')]
    redirect_to root_url
  end
end
