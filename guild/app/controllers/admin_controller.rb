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

  def user
    render layout: false, json: User.find_by(id: params['id']).to_json(include: { login: { only: :email } })
  end

  def add_user
    render json: {
      'response' => LogicUser.create(params['name'], params['email'], params['password'], params['authority']),
    }
  end

  def delete_user
    user = User.find_by(id: params['id'])
    return render json: { 'result' => false, 'error' => 'User not found' } if user.nil?
    if user.admin?
      return render json: { 'result' => false, 'error' => 'Last admin user' } if User.admin.count == 1
    end
    render json: {
      'result' => user.destroy,
    }
  end

  def change_user
    ApplicationRecord.transaction do
      user = User.find(params['id'])
      user.name = params['name']
      user.authority = params['authority'].to_i
      user.login.email = params['email']

      user.login.save!
      user.save!
      render json: { 'result' => true }
    end
  rescue StandardError => e
    Rails.logger.error(e)
    render json: { 'result' => false, 'error' => e.message }
  end

  private

  def admin_user?
    user = User.find(session[:me][:user_id])
    redirect_to controller: :board, action: :index unless user.admin?
  end
end
