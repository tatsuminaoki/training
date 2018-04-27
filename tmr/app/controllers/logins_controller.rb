class LoginsController < ApplicationController
  # GET index
  def index
  end

  # POST /login
  def login
    login_id = params[:login_id]
    password = params[:password]

    password_hash = User.password_hash(login_id, password)
    user = User.find_by(login_id: login_id, password_hash: password_hash)

    if user.present?
      session[:user] = user
      redirect_to tasks_path
    else
      redirect_to login_path, notice: I18n.t('notices.login_invalid')
    end
  end

  # GET /logout
  def logout
    session[:user] = nil
    redirect_to login_path, notice: I18n.t('notices.logged_out')
  end
end
