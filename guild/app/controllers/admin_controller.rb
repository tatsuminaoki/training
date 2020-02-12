# frozen_string_literal: true

class AdminController < ApplicationController
  require 'value_objects/authority'

  before_action :admin_user?

  def index
    render
  end

  def users
    @users = User.all.includes(:login)
    render
  end

  private

  def admin_user?
    user = User.find(session[:me][:user_id])
    redirect_to controller: :board, action: :index if user.authority != ValueObjects::Authority::ADMIN
  end
end
