class Admin::UsersController < ApplicationController
  def index
    @q = User.includes(:tasks).all.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
  end

  def new
    @user = User.new
  end

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

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:login_id, :password, :display_name)
  end
end
