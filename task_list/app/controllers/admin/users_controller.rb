class Admin::UsersController < ApplicationController
  before_action :admin_user
  before_action :set_user, only: %i[show destroy update edit]
  before_action :count_admin_user, only: %i[destroy update]
  before_action :login_check, only: %i[destroy index]
  before_action :user_destroy_login_check, only: %i[destroy]

  def show
    @tasks = @user.tasks.page(params[:page]).per(10)
  end

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: I18n.t('activerecord.flash.user_edit')
    else
      flash[:alert] = "#{@user.errors.count}件のエラーがあります"
      redirect_to admin_user_path(@user)
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: I18n.t('activerecord.flash.user_delete')
  end

  private

  def user_params
    params.require(:user).permit(:admin, :name, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_destroy_login_check
    session.delete(:@user_id) if session[:@user_id].present?
  end

  def login_check
    redirect_to new_user_path if session[:user_id].nil?
  end

  def admin_user
    redirect_to root_path, alert: '管理者以外は閲覧することができません' unless current_user.admin?
  end

  def count_admin_user
    if User.where(admin: true).count == 1 && @user.admin == true && @user == current_user
      redirect_to admin_user_path(@user), alert: I18n.t('activerecord.flash.last_admin_user_delete')
    end
  end
end
