# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :user_is_logged_in
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @q = User.includes(:tasks).all.ransack(params[:q])
      @users = @q.result(distinct: true).page(params[:page])
    end

    def new
      @user = User.new
    end

    # rubocop:disable Metrics/AbcSize
    def create
      @user = User.new(user_params)
      if @user.save
        flash[:success] = [t('.user_saved')]
        redirect_to admin_users_path
      else
        flash.now[:danger] = [(t('something_is_wrong') + t('.user_is_not_saved')).to_s, @user.errors.full_messages].flatten
        render :new
      end
    end
    # rubocop:enable Metrics/AbcSize

    def show
      @tasks = @user.tasks
    end

    def edit; end

    # rubocop:disable Metrics/AbcSize
    def update
      if @user.update(user_params)
        flash[:success] = [t('.user_updated')]
        redirect_to admin_users_path
      else
        flash.now[:danger] = [(t('something_is_wrong') + t('.user_is_not_updated')).to_s, @user.errors.full_messages].flatten
        render :edit
      end
    end
    # rubocop:enable Metrics/AbcSize

    def destroy
      if @user.destroy
        flash[:success] = [t('.user_deleted')]
      else
        flash[:danger] = [(t('something_is_wrong') + t('user_is_not_deleted')).to_s, @user.errors.full_messages].flatten
      end
      redirect_to admin_users_path
    end

    private

    def user_params
      params.require(:user).permit(:login_id, :password, :display_name)
    end

    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = [t('admin.users.user_not_found')]
      redirect_to admin_users_path
    end
  end
end
