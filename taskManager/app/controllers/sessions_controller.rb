class SessionsController < ApplicationController
  skip_before_action :check_authenticate, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session

    redirect_to sign_in_path
  end
end
