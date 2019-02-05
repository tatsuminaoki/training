# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :available?

    def index
      @users = User.all.page(params[:page])
      @users = User.all.search(params[:order_by], params[:order]).page(params[:page])
    end

    def show
      @user = User.find_by(id: params[:id])
      @tasks = Task.search(params[:name], params[:status], params[:order_by], params[:order], user: @user).page(params[:page])
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: create_message('create', 'success')
      else
        flash[:error] = create_message('create', 'error')
        render :new
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      # 管理者自身の権限を一般へ変更することはできない。
      if params[:id].to_i == current_user.id && params[:user][:auth_level].to_s == :normal.to_s
        flash[:error] = create_message('update', 'error') + I18n.t('messages.alert.self_update_to_normal')
        return render :edit
      end
      if @user.update(user_params)
        redirect_to admin_users_path, notice: create_message('update', 'success')
      else
        flash[:error] = create_message('update', 'error')
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      # 管理者自身のユーザ情報を削除することはできない。
      return redirect_to admin_users_path, alert: create_message('delete', 'error') + I18n.t('messages.alert.self_delete') if params[:id].to_i == current_user.id
      if @user.destroy
        redirect_to admin_users_path, notice: create_message('delete', 'success')
      else
        redirect_to admin_users_path, alert: create_message('delete', 'error')
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :auth_level)
    end

    def create_message(action, result)
      I18n.t('messages.action_result', target: I18n.t('activerecord.models.user'), action: I18n.t("actions.#{action}"), result: I18n.t("results.#{result}"))
    end

    def available?
      raise Forbidden unless current_user.admin?
    end
  end
end
