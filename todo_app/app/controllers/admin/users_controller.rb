module Admin
  class UsersController < ApplicationController
    before_action :require_login

    def index
      @users = User.search_all
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        flash[:success] = I18n.t('success.create', it: User.model_name.human)
        redirect_to admin_users_path
      else
        render 'new'
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])

      if @user.update(user_params)
        flash[:success] = I18n.t('success.update', it: User.model_name.human)
        redirect_to admin_users_path
      else
        render 'edit'
      end
    end

    def show
      @user = User.find(params[:id])
    end

    def destroy
      @user = User.find(params[:id])
      @user.delete

      flash[:success] = I18n.t('success.delete', it: User.model_name.human)
      redirect_to admin_users_path
    end

    private

    def user_params
      params.require(:user).permit(:name, :password)
    end

    def require_login
      redirect_to login_path unless current_user?
    end
  end
end
