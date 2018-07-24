class Admin::UsersController < ApplicationController
  protect_from_forgery except: :update # PATCHリクエストで"Can't verify CSRF token authenticity."と表示されるため追加
  before_action :authorize_admin

  def index
    @users = User.all.page(params[:page]).per(10)
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

    if @user.id == current_user.id && params[:user][:admin] == 'general'
      redirect_to ({action: 'edit'}), id: params[:id], alert: I18n.t('flash.failure_change_current_user_role') and return
    end 

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

  private

  def users_params
    params.require(:user).permit(:user_name, :mail_address, :password, :admin)
  end

  def authorize_admin
    redirect_to root_path, alert: I18n.t('flash.require_admin') unless current_user.admin?
  end
end
