class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to tasks_path
      flash[:success] = t('.success')
    else
      flash[:danger] = t('.fail')
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
