class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]

  def show
    @tasks = @user.tasks.page(params[:page]).per(10)
  end

  def index
    @users = User.all
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: I18n.t('activerecord.flash.user_delete')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
