# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[show edit update destroy]

  # GET /admin/users
  def index
    @users = User.all
  end

  # GET /admin/users/1
  def show
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, success: I18n.t('.flash.success.user.create')
    else
      render :new
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    if @user.update(user_params)
      redirect_to admin_users_path, success: I18n.t('.flash.success.user.update')
    else
      render :edit
    end
  end

  # DELETE /admin/users/1
  def destroy
    @user.destroy
    redirect_to admin_users_path, success: I18n.t('.flash.success.user.destroy')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
