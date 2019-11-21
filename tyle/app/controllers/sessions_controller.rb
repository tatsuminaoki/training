# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_sign_in!, only: %i[new create]
  before_action :set_user, only: [:create]

  def new
    @session = Session.new
  end

  def create
    if @user.authenticate(session_params[:password])
      sign_in(@user)
      redirect_to root_path
    else
      redirect_to login_path, alert: t('message.invalid_login_id_or_password')
    end
  end

  def destroy
    sign_out
    redirect_to login_path
  end

  private

  def set_user
    @user = User.find_by!(login_id: session_params[:login_id])
  rescue StandardError
    redirect_to login_path, alert: t('message.invalid_login_id_or_password')
  end

  def session_params
    params.require(:session).permit(:login_id, :password)
  end
end
