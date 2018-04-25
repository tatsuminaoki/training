class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update destroy)

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @tasks = @user.tasks
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = t('flash.user.create')
      redirect_to admin_user_path(@user)
    else
      flash[:alert] = t('flash.user.create_failed')
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = t('flash.user.update')
      redirect_to admin_user_path(@user)
    else
      flash[:alert] = t('flash.user.update_failed')
      render 'edit'
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = t('flash.user.delete')
      redirect_to admin_users_path
    else
      flash[:alert] = t('flash.user.delete_failed')
      render 'index'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :admin)
  end
end
