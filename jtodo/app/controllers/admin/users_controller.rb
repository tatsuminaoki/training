module Admin
  class UsersController < ApplicationController
    before_action :require_login, :admin_user

    def index
      @users = User.page(params[:page]).per(PAGE_PER)
    end
    
    def tasks
      @user = User.find(params[:id])
      @tasks = @user.tasks.page(params[:page]).per(PAGE_PER)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to tasks_path
        flash[:success] = t('.success')
      else
        render 'new'
        flash[:danger] = t('.fail')
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        redirect_to tasks_path
        flash[:success] = t('.success')
      else
        render 'edit'
        flash[:danger] = t('.fail')
      end
    end

    def destroy
      @user = User.find(params[:id])
      if current_user?(@user)
        redirect_to admin_root_path
        flash[:danger] = t('.fail_only_admin')
      elsif @user.destroy
        flash[:success] = t('.success')
        redirect_to admin_root_path
      else
        flash[:danger] = t('fail')
      end
    end

    private

      def user_params
        params.require(:user).permit(:name, :password, :password_confirmation)
      end

      def same_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
      end

      def admin_user
        redirect_to(root_url) unless current_user.is_admin?
      end

  end
end
