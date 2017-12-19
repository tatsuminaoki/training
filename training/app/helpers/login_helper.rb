module LoginHelper
  def logged_in?
    session[:user_id].present?
  end

  def curent_user
    User.find(session[:user_id])
  end
end
