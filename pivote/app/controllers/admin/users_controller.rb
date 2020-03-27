# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_admin
    before_action :find_user, only: %i[show edit update destroy]

    def index
      @users = User.includes(:tasks).all
    end

    def show
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_url, notice: t('flash.create', target: @user.name)
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_url, notice: t('flash.update', target: @user.name)
      else
        render :edit
      end
    end

    def destroy
      if @user.destroy
        redirect_to admin_users_url, notice: t('flash.delete', target: @user.name)
      else
        render :index
      end
    end

    def tasks
      @user = User.find(params[:user_id])
      @tasks = @user.tasks.page(params[:page])
    end

    private

    def require_admin
      redirect_to root_url unless current_user.is_admin
    end

    def user_params
      params.require(:user).permit(:name, :email, :is_admin, :password, :password_confirmation)
    end

    def find_user
      @user = User.find(params[:id])
    end
  end
end
