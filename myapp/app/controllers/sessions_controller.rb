# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_sign_in!, only: %i[new create]
  before_action :set_user, only: [:create]

  def new
    redirect_to projects_path if signed_in?
  end

  def create
    if @user.authenticate(session_params[:password])
      sign_in(@user)
      redirect_to projects_path
    else
      redirect_to login_path, alert: I18n.t('.flash.invalid_login')
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find_by!(email: session_params[:email])
  rescue StandardError
    redirect_to login_path, alert: I18n.t('.flash.invalid_login')
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
