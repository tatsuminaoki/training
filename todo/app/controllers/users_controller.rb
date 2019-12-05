# frozen_string_literal: true

class UsersController < ApplicationController
  # GET /signup
  def new
    @user = User.new
  end

  # POST /users/create
  def create
    @user = User.new(user_params)
    return render :new unless @user.save
    flash[:success] = 'Success!'
    redirect_to tasks_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
