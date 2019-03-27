class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]
  before_action :login_check, only: %i[destroy index]
  before_action :user_destroy_login_check, only: %i[destroy]

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

  def user_destroy_login_check
    session.delete(:user_id) if session[:user_id].present?
  end

  def login_check
    redirect_to new_user_path if session[:user_id].nil?
  end
end
