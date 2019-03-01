class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      puts 'find'
      log_in user
      redirect_to tasks_url, notice: 'login!'
    else
      puts 'else'
      flash.now[:danger] = 'Invaild email/password'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
