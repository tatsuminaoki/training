# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :user, only: %i[show edit update destroy]

    def index
      @users = User.eager_load(:tasks).order(created_at: :desc)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_user_path(@user), notice: t('message.user.created')
      else
        render :new
      end
    end

    def show
      @tasks = Task.where(user_id: @user.id)
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: t('message.user.updated')
      else
        render :edit
      end
    end

    def destroy
      if current_user == @user
        redirect_to admin_user_path(@user)
      elsif @user.destroy
        redirect_to admin_users_path, notice: t('message.user.destroyed')
      else
        redirect_to admin_users_path
      end
    end

    private

    def user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :login_id, :password, :password_confirmation, :role)
    end
  end
end
