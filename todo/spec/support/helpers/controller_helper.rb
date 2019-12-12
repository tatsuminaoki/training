# frozen_string_literal: true

module ControllerHelper
  def add_session(user)
    session[:user_id] = user.id
  end
end
