class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  PER = 8

  def index
    @search = User.with_task_count.ransack(params[:q])
    @search_tasks = @search.result.page(params[:page]).per(PER)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path,
                  notice: I18n.t('notification.create', value: @user.name)
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path,
                  notice: I18n.t('notification.update', value: @user.name)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path,
                notice: I18n.t('notification.destroy', value: @user.name)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
