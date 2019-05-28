# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_login, except: %i[new create]
  before_action :set_user, only: %i[show edit update destroy]
  before_action -> { correct_user(@user) }, except: %i[new create]

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      redirect_to root_path, success: I18n.t('.flash.success.user.create')
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, success: I18n.t('.flash.success.user.update')
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    if @user.destroy
      redirect_to login_path, success: I18n.t('.flash.success.user.destroy')
    else
      redirect_to user_path(@user), danger: @user.errors[:base][0]
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
