# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_session

  before_action :redirect_if_logged_in, only: %i[new create]

  before_action :require_user, only: :create

  def new
  end

  def create
    if user.user_credential&.authenticate(params[:session][:password])
      session[:current_user_id] = user.id

      redirect_to root_path
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが違います。'
      render :new
    end
  end

  def destroy
    if current_user
      session.delete(:current_user_id)
      @current_user = nil
    end
    redirect_to new_session_path, success: 'ログアウトしました。'
  end

  private

  def user
    @user ||= User.find_by(email: params[:session][:email])
  end

  def require_user
    return if user.present?
    flash.now[:danger] = 'メールアドレスまたはパスワードが違います。'
    render :new
  end

  def redirect_if_logged_in
    redirect_to root_path if current_user
  end
end
