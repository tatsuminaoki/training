# frozen_string_literal: true

class SessionsController < ApplicationController
  # GET /login
  def new
  end

  # POST /sessions/create
  def create
    user = User.find_by(name: login_params[:name].downcase)
    if user&.authenticate(login_params[:password])
      log_in user
      redirect_to tasks_path
    else
      flash[:danger] = I18n.t('errors.wrong_name_or_password')
      render :new
    end
  end

  # DELETE /logout
  def destroy
    log_out
    redirect_to login_path
  end

  private

  def login_params
    params[:session]
  end
end
