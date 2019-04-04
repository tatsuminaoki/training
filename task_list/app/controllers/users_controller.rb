class UsersController < ApplicationController
  before_action :check_current_user, only: %i[show edit update]
  before_action :set_user, only: %i[edit update]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = '登録しました。ログインしてください。'
      redirect_to new_session_path
    else
      flash[:alert] = I18n.t('activerecord.flash.errors_count', errors_count: @user.errors.count)
      render 'new'
    end
  end

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: I18n.t('activerecord.flash.user_edit')
    else
      flash[:alert] = I18n.t('activerecord.flash.errors_count', errors_count: @user.errors.count)
      render 'edit'
    end
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def check_current_user
    set_user
    redirect_to tasks_path, alert: '本人しか閲覧、編集できません' if current_user != @user
  end

  def set_user
    @user = User.find(params[:id])
  end
end
