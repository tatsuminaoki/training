# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: t(:logged_in)
    else
      flash.now[:message] = t :login_failed_msg
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:message] = t :logged_out
    redirect_to login_url
  end
end
