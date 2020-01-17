class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all.page(params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id unless session[:user_id]
      redirect_to root_path, notice: "Thank you for signing up!"
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'create new sentence'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      session[:user_id] = nil if @user.id == session[:user_id]
      redirect_to users_url, notice: 'create new sentence'
    else
      redirect_to users_url, notice: 'create new sentence'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
