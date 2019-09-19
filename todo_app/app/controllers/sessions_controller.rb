# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action -> { redirect_to tasks_path }, only: %i[new create], if: :logged_in?

  def new
  end

  def create
    login_params = params.require(:session).permit(:email, :password)
    user = login_params[:email] ? User.find_by(email: login_params[:email]) : nil

    if user&.authenticate(login_params[:password])
      login user
      redirect_to tasks_path
    else
      flash[:error] = '入力された情報が正しくありません'
      render :new
    end
  end
end
