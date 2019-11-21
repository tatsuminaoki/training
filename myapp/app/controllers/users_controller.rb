# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :require_login

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:message] = t :new_user_created
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :account, :password)
  end
end
