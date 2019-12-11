class Admin::UsersController < ApplicationController
  before_action :require_login

  # GET /admin/users
  def index
    @users = User.all.page(params[:page])
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # POST /admin/users
  def create
    @user = User.new(user_params)
    return render :new unless @user.save
    flash[:success] = 'Success!'
    redirect_to admin_users_path
  end

  # GET /admin/users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  # PATCH /admin/users/:id
  def update
    @user = User.find(params[:id])
    return render :edit unless @user.update(user_params)
    flash[:success] = 'Success!'
    redirect_to admin_users_path
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
