# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
    redirect_to root_path if session[:user_id]
  end

  def create
    user = User.find_by(email: take_email)

    if user&.authenticate(take_password)
      session[:user_id] = user.id
      redirect_to root_path, flash: { success: I18n.t('flash.login.success') }
    else
      flash.now[:danger] = I18n.t('flash.login.failed')
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to login_path, flash: { success: I18n.t('flash.logout') }
  end

  private

  def take_email
    session_params[:email]
  end

  def take_password
    session_params[:password]
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
