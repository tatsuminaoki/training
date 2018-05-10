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

      # 管理者ログインの場合、ユーザ一覧を表示
      return redirect_to users_path if user.admin_flag?

      # タスク一覧
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
    @user = User.new(login_id: params[:login_id])
    password = params[:password]

    message = User.check_input_values(@user.login_id, password)

    if message.present?
      flash.now[:notice] = message
      render 'signup'
    else
      @user.password_hash = User.password_hash(@user.login_id, password)

      if !@user.save
        flash.now[:notice] = @user.errors.full_messages[0]
        render 'signup'
        return
      end

      session[:user] = @user
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
