# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save!
    redirect_to root_path, flash: { success: t('flash.user.create_success') }
  rescue StandardError
    flash.now[:danger] = t('flash.user.create_failure')
    Rails.logger.error(e.message)
    render :new
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
