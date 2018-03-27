# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'login'

  def new
  end

  def create
    user = User.find_by(name: user_name)
    if user&.authenticate(password)
      log_in user.id
      redirect_to tasks_path
    else
      flash[:danger] = I18n.t('errors.messages.invalid_login')
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def user_name
    request_params[:name]
  end

  def password
    request_params[:password]
  end

  def request_params
    params.require(:sessions).permit(:name, :password)
  end
end
