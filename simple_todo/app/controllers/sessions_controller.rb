class SessionsController < ApplicationController
  def new
  end

  def create
    puts params[:session][:email].to_s
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invaild email/password'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
