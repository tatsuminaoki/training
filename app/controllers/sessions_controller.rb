class SessionsController < ApplicationController
  skip_before_action :require_sign_in!, only: [:new, :create]
  before_action :set_user, only: [:create]

  def new
  end

  def create
    if @user.authenticate(params[:password])
      sign_in(@user)
      redirect_to root_path, success: 'ログインしました'
    else
      render 'new', warning: 'ログインに失敗しました'
    end
  end

  def destroy
    sign_out
    redirect_to login_path, info: 'ログアウトしました'
  end

  private

  def set_user
    @user = User.find_by!(mail: params[:mail])
  rescue
    render action: 'new'
  end
end
