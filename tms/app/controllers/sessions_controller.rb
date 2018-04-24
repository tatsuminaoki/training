class SessionsController < ApplicationController
  skip_before_action :require_sign_in!, only: [:new, :create]
  before_action :set_user, only: :create

  def new
  end

  def create
    if params[:sessions][:name].blank? or params[:sessions][:password].blank?
      flash[:alert] = t('flash.user.blank')
      render 'new'
    else
      if @user.authenticate(user_params[:password])
        sign_in(@user)
        flash[:notice] = t('errors.messages.valid_login')
        redirect_to root_path
      else
        flash[:alert] = t('errors.messages.invalid_login')
        render 'new'
      end
    end
  end

  def destroy
    sign_out
    flash[:notice] = t('errors.messages.valid_logout')
    redirect_to login_path
  end

  private

  def set_user
    @user = User.find_by(name: params[:sessions][:name])

    if @user.blank?
      flash[:alert] = t('flash.user.non_exist')
      render 'new'
    end
  end

  def user_params
    params.require(:sessions).permit(:name, :password)
  end
end
