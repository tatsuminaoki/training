class SessionsController < ApplicationController
  before_action :login_check, only: %i[new create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = 'ログインしました'
      redirect_to tasks_path(user.id)
    else
      flash[:alert] = 'ログインに失敗しました'
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end

  private

  def login_check
    redirect_to new_session_path, alert: 'もうログインしています' if session[:user_id].present?
  end
end
