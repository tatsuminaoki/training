class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :login_required_as_admin

  PER = 8

  def index
    @search = User.with_task_count.ransack(params[:q])
    @search_tasks = @search.result.page(params[:page]).per(PER)
  end

  def show
    @search = @user.tasks.ransack(params[:q])
    @search_tasks = @search.result.page(params[:page]).per(PER)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_path(@user),
                  notice: I18n.t('notification.create', value: @user.name)
    else
      render :new
    end
  end

  def update
    @user.assign_attributes(user_params)
    if @user.myself?(@current_user) && @user.role_changed?
      redirect_to admin_users_path,
                  notice: I18n.t('notification.update_failed_myself_role')
    elsif @user.update(user_params)
      redirect_to admin_users_path,
                  notice: I18n.t('notification.update', value: @user.name)
    else
      render :edit
    end
  end

  def destroy
    if @user.myself?(@current_user)
      redirect_to admin_users_path,
                  notice: I18n.t('notification.destroy_failed_myself')
    else
      @user.destroy
      redirect_to admin_users_path,
                  notice: I18n.t('notification.destroy', value: @user.name)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def login_required_as_admin
    return if current_user&.admin?

    sign_out
    redirect_to login_path, notice: t('sessions.flash.logout')
  end
end
