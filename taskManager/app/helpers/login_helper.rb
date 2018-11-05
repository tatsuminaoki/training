module LoginHelper
  def logged_in?
    return false unless session[:session_key] && session[:user_id]
    return true
  end
end
