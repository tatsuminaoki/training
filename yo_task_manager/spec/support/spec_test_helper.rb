
# frozen_string_literal: true

module SpecTestHelper
  def login(user)
    user = User.find_by(login_id: user.to_s) if user.is_a?(Symbol)
    request.session[:user_id] = user.id
  end

  def current_user
    User.find(request.session[:user_id])
  end
end
