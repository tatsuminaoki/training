class UsersController < ApplicationController
  before_action :check_current_user, only: [:show]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = '登録しました。ログインしてください。'
      redirect_to new_session_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def check_current_user
    @user = User.find(params[:id])
    redirect_to tasks_path, alert: '本人しか閲覧できません' if current_user != @user
  end
end
