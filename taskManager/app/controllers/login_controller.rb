class LoginController < ApplicationController
  skip_before_action :check_session
  require 'redis'
  require 'json'

  def index
    @user = User.new
    render :action => 'index'
  end

  def create
    user_params = params[:user]
    result_user = User.find_by(mail: user_params[:mail])
    if result_user && result_user.authenticate(user_params[:password])
      make_session(user: result_user)

      # TODO: リダイレクト先は決められるようにした方がいい
      redirect_to :controller => 'list',:action => 'index'
    else
      flash[:notice] = I18n.t("messages.password_error")
      @user = User.new
      render :action => 'index'
    end
  end

  def logout
    progress_logout
  end
end
