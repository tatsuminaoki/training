class UsersController < ApplicationController
  before_action :forbid_login_user, { only: %i(new create login login_post) }

  def login
  end

  def login_post
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = I18n.t('flash.users.login.success')
      redirect_to(root_path)
    else
      @error_message = I18n.t('flash.users.login.failure')
      render :login
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = I18n.t('flash.users.logout')
    redirect_to(login_path)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(name: params[:name], password: params[:password])
    save_users('signup', root_path, :new)
  end
end
