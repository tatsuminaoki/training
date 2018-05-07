class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update]
  before_action :same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path
      flash[:success] = t('.success')
    else
      flash[:danger] = t('.fail')
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to root_path
      flash[:success] = t('.success')
    else
      flash[:danger] = t('.fail')
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end

  def same_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

end
