class SessionsController < ApplicationController
  before_action :set_user, only: [:create]

  def new
  end

  def create
    # if @user.authenticate(session_params[:password])
    if @user.authenticate(params[:password])
      sign_in(@user)
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to login_path
  end

  private

  def set_user
    # @user = User.find_by!(login_id: session_params[:login_id])
    @user = User.find_by!(login_id: params[:login_id])
    logger.debug(@user.id)
    logger.debug(@user.name)
    logger.debug(@user.login_id)
    logger.debug(@user.password_digest)
  rescue
    render action: 'new'
  end

  def session_params
    params.require(:session).permit(:login_id, :password)
  end
end
