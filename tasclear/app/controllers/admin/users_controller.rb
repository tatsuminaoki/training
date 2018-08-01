# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]
    before_action :check_admin

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.save!
      redirect_to admin_users_path, notice: t('flash.user.create_success')
    rescue StandardError
      render :new
    end

    def edit
    end

    def show
      @tasks = @user.tasks
    end

    def update
      @user.update!(user_params)
      redirect_to admin_users_path, notice: t('flash.user.update_success')
    rescue StandardError
      render :edit
    end

    def destroy
      @user.destroy!
      redirect_to admin_users_path, notice: t('flash.user.destroy_success')
    rescue StandardError
      redirect_to admin_users_path, alert: t('errors.messages.at_least_one_admin')
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :role)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def check_admin
      redirect_to root_path, alert: t('flash.user.not_admin') unless current_user.admin?
    end
  end
end
