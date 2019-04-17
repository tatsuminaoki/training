class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # TODO: ログイン処理

      redirect_to root_path
    else
      flash.now[:danger] = t('session.login.failed')
      render 'new'
    end
  end

  def destroy
  end
end
