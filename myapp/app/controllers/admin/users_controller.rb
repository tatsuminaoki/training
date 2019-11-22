# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    layout 'admin/user'

    before_action :find_user, only: %i[edit update show destroy]
    before_action :ensure_admin

    def index
      @users = User.all.page params[:page]
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        flash[:message] = t :new_user_created
        redirect_to admin_user_path(@user)
      else
        render 'new'
      end
    end

    def show
      @tasks = @user.tasks.find_with_params(params)
    end

    def edit; end

    def update
      if @user.update(user_params)
        flash[:message] = t :user_updated
        redirect_to admin_user_path(@user)
      else
        render 'edit'
      end
    end

    def destroy
      if @user.destroy
        flash[:message] = t :user_deleted
        redirect_to admin_users_path
      else
        flash[:message] = @user.errors[:base].first if @user.errors[:base].present?
        redirect_back(fallback_location: admin_users_path)
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :account, :password, :role)
    end

    def find_user
      @user = User.find(params[:id])
    end

    def ensure_admin
      redirect_to root_path unless @current_user.admin?
    end
  end
end
