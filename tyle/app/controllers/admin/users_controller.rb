# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :user, only: %i[show edit update destroy]

    def index
      @users = User.eager_load(:tasks).order(created_at: :desc)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params_with_enums_converted)
      if @user.save
        redirect_to admin_user_path(@user), notice: t('message.user.created')
      else
        render :new
      end
    end

    def show
      @tasks = Task.where(user_id: @user.id)
    end

    def edit
    end

    def update
      # There are four patterns; so two independent booleans.
      # 1. The user tries to change its password or not.
      # 2. The params(name and login_id) are valid or not.
      change_password = (user_params_with_enums_converted[:password] != '' || user_params_with_enums_converted[:password_confirmation] != '')
      params_are_valid = (user_params_with_enums_converted[:name] != '' && user_params_with_enums_converted[:login_id] != '')

      # those four patterns
      if change_password
        if @user.update(user_params_with_enums_converted)
          redirect_to admin_user_path(@user), notice: t('message.user.updated')
        else
          render :edit
        end
      else
        if params_are_valid
          @user.name = user_params_with_enums_converted[:name]
          @user.login_id == user_params_with_enums_converted[:login_id]

          # Skip validation since the name and login_id should be valid.
          if @user.save(validate: false)
            redirect_to admin_user_path(@user), notice: t('message.user.updated')
          else
            render :edit
          end
        else
          @user.update(user_params_with_enums_converted)

          # The user does not try to change its password. So the password error messages should disappear.
          @user.errors.messages.delete(:password)

          render :edit
        end
      end
    end

    def destroy
      if current_user == @user
        flash[:warning] = t('message.delete_itself')
        redirect_to admin_user_path(@user)
      elsif @user.destroy
        redirect_to admin_users_path, notice: t('message.user.destroyed')
      else
        flash[:warning] = t('message.user.destroy_failure')
        redirect_to admin_users_path
      end
    end

    private

    def user
      @user ||= User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :login_id, :password, :password_confirmation, :role)
    end

    # Convert the number of enums; '0' -> 0
    def user_params_with_enums_converted
      user_params_copy = user_params
      user_params_copy[:role] = user_params[:role].to_i
      user_params_copy
    end
  end
end
