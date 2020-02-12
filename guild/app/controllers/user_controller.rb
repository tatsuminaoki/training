# frozen_string_literal: true

class UserController < ApplicationController
  require 'logic_user'

  def login_top
    render template: 'login'
  end

  def login
    render json: {
      'response' => LogicUser.authenticate(session, params['email'], params['password']),
    }
  end

  def logout
    reset_session
    render json: {
      'response' => { 'result' => session[:me].blank? },
    }
  end
end
