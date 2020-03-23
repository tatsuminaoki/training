module SignInHelper
  def sign_in(current_user)
    remember_token = User.new_remember_token
    cookies[:user_remember_token] = remember_token
    current_user.update!(remember_token: User.encrypt(remember_token))
  end
end
