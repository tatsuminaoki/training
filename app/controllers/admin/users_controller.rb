# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :user, only: %i[show]

  def index
    @users = User.all.order(created_at: :desc)
  end

  def new
    @user = User.new.tap(&:build_user_credential)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, success: t('messages.created', item: @user.model_name.human)
    else
      render :new
    end
  end

  def show
  end

  private

  def user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :email_confirmation,
      user_credential_attributes: [
        :password,
        :password_confirmation,
      ]
    )
  end
end
