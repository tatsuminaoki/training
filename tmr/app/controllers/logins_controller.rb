class LoginsController < ApplicationController


  # Show Login Page
  # GET index
  def index
  end

  # Login
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

  # Show Signup Page
  # GET /signup
  def signup
  end

  # Create User
  # POST /register
  def register
    login_id = params[:login_id]
    password = params[:password]

    if !password.present?
      redirect_to signup_path,
                  notice: I18n.t('activerecord.attributes.user.password') + I18n.t('activerecord.errors.messages.blank')
    elsif password.length < User::PASSWORD_MIN_LENGTH
      redirect_to signup_path,
                  notice: I18n.t('activerecord.attributes.user.password') + I18n.t('activerecord.errors.messages.too_short', count: 4)
    elsif !login_id.present?
      redirect_to signup_path,
                  notice: I18n.t('activerecord.attributes.user.login_id') + I18n.t('activerecord.errors.messages.blank')
    else
      password_hash = User.password_hash(login_id, password)
      user = User.create(login_id: login_id, password_hash: password_hash)

      session[:user] = user
      redirect_to tasks_path
    end
  end

  # Logout
  # GET /logout
  def logout
    session[:user] = nil
    redirect_to login_path, notice: I18n.t('notices.logged_out')
  end
end
