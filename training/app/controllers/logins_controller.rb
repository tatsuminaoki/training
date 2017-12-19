class LoginsController < ApplicationController
  include LoginHelper

  def new
    redirect_to root_path, notice: I18n.t('logins.controller.messages.logged_in') if logged_in?
  end

  def create
    @email = params[:email]
    @password = params[:password]

    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: I18n.t('logins.controller.messages.logged_in')
    else
      flash[:notice] = I18n.t('logins.controller.messages.invalid')
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to logins_new_path, notice: I18n.t('logins.controller.messages.logged_out')
  end
end
