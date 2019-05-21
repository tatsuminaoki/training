# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[create]

  def new
  end

  def create
    if @user&.authenticate(params[:session][:password])
      log_in @user
      redirect_to user_tasks_path(@user)
    else
      flash.now[:danger] = I18n.t('.flash.errors.session_params')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

  private

  def set_user
    @user = User.find_by(name: params[:session][:name])
  end
end
