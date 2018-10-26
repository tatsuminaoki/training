# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to index_url unless session[:user_id].nil?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to index_url, flash: { success: t('flash.session.login_success') }
    else
      flash.now[:danger] = t('flash.session.login_failed')
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_url, flash: { success: t('flash.session.logout_success') }
  end
end
