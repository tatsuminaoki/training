class SessionsController < ApplicationController
  before_action :loggin_check, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:alert] = 'ログインしました'
      redirect_to user_path(user.id)
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

  def loggin_check
    if session[:user_id] != nil
      redirect_to new_session_path, notice:'もうログインしています'
    end
  end
end
