# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
    redirect_to root_path if session[:user_id]
  end

  def create
    if user_authenticated?(User.find_by(email: session_params[:email]))
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

  def user_authenticated?(user)
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      true
    else
      false
    end
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
