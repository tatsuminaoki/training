class Admin::UsersController < ApplicationController
  before_action :require_login

  def index
    @users = User.all.page(params[:page])
  end

  def new
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
  end
end
