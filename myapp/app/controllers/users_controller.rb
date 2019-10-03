# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :require_sign_in!, only: %i[new create]
  before_action :valid_user, only: [:create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(@param_user)
    @user.save!
    flash[:success] = '登録しました。'
    redirect_to login_path
  rescue StandardError => e
    logger.error e
    flash[:danger] = '登録に失敗しました'
    render :new
  end

  private

  def valid_user
    @param_user = params.require(:user).permit(:login_id, :password, :password_confirmation)
  end
end
