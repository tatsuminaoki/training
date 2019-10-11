class Admin::UsersController < ApplicationController
  def index
    @q = User.includes(:tasks).all.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
