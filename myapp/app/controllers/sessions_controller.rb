# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :find_user
  skip_before_action :require_login

  def new
  end

  def create
    if @user && @user&.authenticate(params[:password])
      session[:user_id] = @user.id
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

  private

  def find_user
    @user = User.find_by(account: params[:account])
  end
end
