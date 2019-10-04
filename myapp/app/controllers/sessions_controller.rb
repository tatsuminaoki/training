# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_sign_in!, only: %i[new create]
  before_action :valid_session, only: [:create]

  def new
  end

  def create
    @user = User.find_by!(login_id: @param_session[:login_id])

    @user.authenticate(@param_session[:password])
    sign_in(@user)
    redirect_to root_path
  rescue StandardError => e
    logger.error e
    flash[:danger] = 'ログインに失敗しました'
    render :new
  end

  def destroy
    sign_out
    flash[:success] = 'ログアウトしました'
    redirect_to login_path
  end

  def valid_session
    @param_session = params.permit(:login_id, :password)
    if @param_session[:login_id].blank? || @param_session[:password].blank?
      flash[:danger] = 'ログインIDとパスワードは必須入力です'
      render :new
    end
  end
end
