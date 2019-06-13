# frozen_string_literal: true

class UserCredentialsController < ApplicationController
  skip_before_action :require_session

  before_action :require_valid_user

  def new
    @user_credential = UserCredential.new
  end

  def create
    @user_credential = user_token.user.build_user_credential(user_credential_params)

    if @user_credential.save
      user_token.destroy!
      render :create
    else
      render :new
    end
  end

  private

  def require_valid_user
    raise Forbidden unless user_token.expires_at >= Time.zone.now
  end

  def user_token
    @user_token ||= UserToken.find_by!(token: params[:id])
  end

  def user_credential_params
    params.require(:user_credential).permit(
      :password,
      :password_confirmation,
    )
  end
end
