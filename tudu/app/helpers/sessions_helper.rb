module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if user_id = session[:user_id]
      user ||= User.find(user_id)
    end
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete(:user_id)
  end
end
