module Admin
  class UsersController < ApplicationController
    before_action :require_login

    def index
      @search_name = params[:search_name]
      @users = User.search_all
      @users = @users.search_by_name(@search_name) if @search_name.present?
    end

    def tasks
      set_search_params
      @user = User.search_by_id(params[:id])
      @task_count = Task.count_by_status(params[:id])
      @tasks = Task.search(user_id: params[:id], title: @search_title, status: @search_status, sort: @search_sort, page: @page)
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
        render :new
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
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy

      flash[:success] = I18n.t('success.delete', it: User.model_name.human)
      redirect_to admin_users_path
    end

    private

    def user_params
      params.require(:user).permit(:name, :password)
    end

    def set_search_params
      @search_title = params[:search_title]
      @search_status = params[:search_status]
      @search_sort = params[:search_sort]
      @page = params[:page]
    end

    def require_login
      redirect_to login_path unless logged_in?
    end
  end
end
