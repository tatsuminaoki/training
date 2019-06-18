# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :require_session

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      token = @user.user_tokens.create!
      UserMailer.password_set_mail(token).deliver_now
      render :create
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :email_confirmation,
    )
  end
end
