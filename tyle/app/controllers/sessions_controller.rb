class SessionsController < ApplicationController
  skip_before_action :require_sign_in!, only: [:new, :create]
  before_action :set_user, only: [:create]

  def new
  end

  def create
    # @user.password = session_params[:password]
    @user.password = params[:password]
    # TODO: user.authenticate needs user.password!!!
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
  rescue
    render action: 'new'
  end

  def session_params
    params.require(:session).permit(:login_id, :password)
  end
end
