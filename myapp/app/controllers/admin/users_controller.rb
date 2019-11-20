class Admin::UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  PER = 20

  def index
    @users = User.preload(:tasks).page(params[:page]).per(PER)
  end

  def show
    @user = User.preload(:tasks).find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = t('flash.update.success')
      redirect_to admin_user_path(@user.id)
    else
      flash.now[:danger] = t('flash.update.fail')
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = t('flash.remove.success')
    else
      flash[:danger] = t('flash.remove.fail')
    end
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
