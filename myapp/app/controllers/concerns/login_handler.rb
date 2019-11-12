module LoginHandler
  def current_user
    remember_token = UserSession.encrypt(cookies[:user_remember_token])
    @current_user ||= UserSession.find_by(session: remember_token)
  end

  def sign_in(user)
    remember_token = UserSession.new_remember_token
    cookies.permanent[:user_remember_token] = remember_token
    user_session = UserSession.find_by(user_id: user.id)
    if user_session
      user_session.update(session: UserSession.encrypt(remember_token))
    else
      UserSession.create(user_id: user.id, session: UserSession.encrypt(remember_token))
    end
    @current_user = user
  end

  def sign_out
    cookies.delete(:user_remember_token)
    @current_user = nil
  end

  def signed_in?
    @current_user.present?
  end

  private

  def require_sign_in!
    redirect_to login_path unless signed_in?
  end
end
