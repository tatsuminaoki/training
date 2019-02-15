# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :find_user, only: %i[destroy]

    def index
      @users = User.search(params).page(params[:page])
    end

    def destroy
      if @user == current_user
        flash[:danger] = I18n.t('flash.user_self_destroy')
      elsif @user.destroy
        flash[:success] = create_flash_message('destroy', 'success', @user, :email)
      else
        flash[:danger] = create_flash_message('destroy', 'failed', @user, :email)
      end

      redirect_to admin_root_url
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def find_user
      @user = User.find(params[:id])
    end
  end
end
