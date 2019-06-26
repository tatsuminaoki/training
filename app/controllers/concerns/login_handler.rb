module LoginHandler
  def current_user
    remember_token = User.encrypt(cookies[:user_remember_token])
    @current_user ||= User.find_by(remember_token: remember_token, mail: cookies[:mail])
  end

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:user_remember_token] = remember_token
    cookies.permanent[:mail] = user.mail
    user.update!(remember_token: User.encrypt(remember_token))
    @current_user = user
  end

  def sign_out
    @current_user = nil
    cookies.delete(:user_remember_token)
  end

  def signed_in?
    @current_user.present?
  end

  def require_sign_in
    redirect_to login_path unless signed_in?
  end
end
