# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]

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
    end

    def update
    end

    def destroy
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
   end

    def set_user
      @user = User.find(params[:id])
   end
  end
end
