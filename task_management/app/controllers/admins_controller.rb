class AdminsController < ApplicationController
  protect_from_forgery except: :update # PATCHリクエストで"Can't verify CSRF token authenticity."と表示されるため追加
  def index
    @users = User.all.page(params[:page]).per(10)
    @task_quantity = []
    @users.each do |user|
      @task_quantity << Task.where(user_id: user.id).size
    end
  end

  def show
    @user = User.find(params[:id])
    @tasks = Task.where(user_id: @user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      redirect_to ({action: 'index'}), notice: I18n.t('flash.success_create_user')
    else
      flash.now[:alert] = I18n.t('flash.failure_create_user')
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(users_params)
      redirect_to ({action: 'show'}), id: params[:id], notice: I18n.t('flash.success_update_account_info')
    else
      flash.now[:alert] = I18n.t('flash.failure_update_account_info')
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.id == session[:user_id]
      redirect_to ({action: 'show'}), id: params[:id], alert: I18n.t('flash.failure_delete_loggined_user') and return
    end

    if @user.destroy
      redirect_to ({action: 'index'}), notice: I18n.t('flash.success_delete_user', user: @user.user_name)
    else
      redirect_to ({action: 'show'}), id: params[:id], alert: I18n.t('flash.failure_delete_user', user: @user.user_name)
    end
  end

  def users_params
    params.require(:user).permit(:user_name, :mail_address, :password)
  end
end
