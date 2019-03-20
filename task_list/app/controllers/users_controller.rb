class UsersController < ApplicationController
  # before_action :authenticate_user!, :only => [:show]
  before_action :user_check, only: [:show]
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

  def user_check
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to tasks_path, notice:'本人しか閲覧できません'
    end
  end
end
