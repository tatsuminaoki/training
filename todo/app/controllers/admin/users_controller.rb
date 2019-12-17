# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_login
    before_action :require_admin_role

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

    # GET /admin/users/:id
    def show
      @user = User.find(params[:id])
      @tasks = @user.tasks.page(params[:page])
    end

    # DELETE /admin/users/:id
    def destroy
      @user = User.find(params[:id])
      if @user.destroy
        flash[:success] = 'Deleted'
        redirect_to admin_users_path
      else
        flash[:error] = @user.errors.full_messages.join("\n")
        @tasks = @user.tasks.page(params[:page])
        render :show
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :role)
    end

    def require_admin_role
      return if current_user.admin?
      flash[:error] = 'You cannot access this section'
      redirect_to tasks_path
    end
  end
end
