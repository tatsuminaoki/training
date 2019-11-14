# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :require_sign_in!, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = 0
    if @user.save
      redirect_to login_path, notice: t('message.user.created')
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :login_id, :password, :password_confirmation)
  end
end
