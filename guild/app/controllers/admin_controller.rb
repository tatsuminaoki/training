# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :admin_user?

  def index
    render
  end

  def users
    @users = User.all.includes(:login)
    render
  end

  def all_users
    render layout: false, json: User.all.includes(:login).to_json(include: { login: { only: :email } })
  end

  def add_user
    render json: {
      'response' => LogicUser.create(params['name'], params['email'], params['password'], params['authority']),
    }
  end

  private

  def admin_user?
    user = User.find(session[:me][:user_id])
    redirect_to controller: :board, action: :index if user.authority != ValueObjects::Authority::ADMIN
  end
end
