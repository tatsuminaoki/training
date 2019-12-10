# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    return render :new unless @user.save
    flash[:success] = 'Success!'
    log_in @user
    redirect_to tasks_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
