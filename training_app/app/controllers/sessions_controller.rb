# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :check_authenticate

  def new
    @user = User.new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      authenticate_redirect
    else
      redirect_to sign_in_path, notice: t('.retry')
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session

    redirect_to sign_in_path
  end

  private

  def authenticate_redirect
    return redirect_to params[:redirect_to], notice: t('.logged_in') \
      if params[:redirect_to].present?

    redirect_to tasks_path, notice: t('.logged_in')
  end
end
