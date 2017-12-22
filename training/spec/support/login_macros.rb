module LoginMacros
  def set_user_session
    session[:user_id] = FactoryBot.create(:user).id
  end

  def get_user_session
    session[:user_id]
  end
end
