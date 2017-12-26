module LoginHelper
  def logged_in?
    session[:user_id].present?
  end

  def current_user
    User.find(session[:user_id])
  end

  def admin_role?
    current_user.admin?
  end
end
