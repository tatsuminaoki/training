class UsersController < ApplicationController
  skip_before_action :require_sign_in, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to tasks_path, success: 'ユーザーを作成しました'
    else
      render 'new', warning: 'ユーザーの作成に失敗しました'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :mail, :password, :password_confirmation)
  end
end
