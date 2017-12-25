class Admin::UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to [:admin, @user], notice: I18n.t('admin.controller.messages.created')
    else
      render :new
    end
  rescue
    flash.now[:alert] = I18n.t('admin.controller.messages.create_failed')
    render :new
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(update_params)
      redirect_to [:admin, @user], notice: I18n.t('admin.controller.messages.updated')
    else
      render :edit
    end
  rescue
    flash.now[:alert] = I18n.t('admin.controller.messages.update_failed')
    render :edit
  end

  def destroy
    User.find(params[:id]).destroy!
    redirect_to admin_users_path, notice: I18n.t('admin.controller.messages.deleted')
  rescue
    redirect_to admin_users_path, alert: I18n.t('admin.controller.messages.delete_failed')
  end

  private

  def update_params
    params[:password].present? ? user_params_without_password : user_params
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
    )
  end

  def user_params_without_password
    params.require(:user).permit(
      :name,
      :email,
    )
  end
end
