class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      puts 'find'
      log_in user
      redirect_to tasks_url, notice: I18n.t('messages.welcome')
    else
      puts 'else'
      flash.now[:danger] = I18n.t('messages.wrong_info')
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
