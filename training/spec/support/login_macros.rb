module LoginMacros
  def set_user_session
    session[:user_id] = FactoryBot.create(:user).id
  end
end
